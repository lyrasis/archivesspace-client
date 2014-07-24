module ArchivesSpace

  class Client

    include Errors

    include DigitalObjects
    include Groups
    include Import
    include Repository
    include System
    include Users

    class Backend
      attr_accessor :backend
      def initialize(host, port, path = "", headers = {})
        @backend = RestClient::Resource.new("#{host}:#{port}/#{path.strip}", headers: headers)
      end
    end # BACKEND

    attr_accessor :host, :port, :headers, :client, :templates

    def initialize(host = "localhost", port = 8089, headers = {})
       @host = host
       @port = port
       @headers = {}
       @client = Backend.new(host, port, "", headers)
       @templates = {}

      # load templates for new objects
      Dir["#{path_to_templates}/*.json"].each do |template_file|
        type = template_file.split("/")[-1].split(".")[0]
        template = JSON.parse( IO.read(template_file) )
        @templates[type] = template
      end
      
    end

    def log(logger = STDOUT)
      RestClient.log = logger
    end

    # needs some error handling
    def login(user, password)
      result    =  client.backend["users/#{user}/login"].post( { password: password } )
      token = JSON.parse( result )["session"]
      @headers = { "X-ArchivesSpace-Session" => token }
      @client = Backend.new(host, port, "", headers)
    end

    # check status
    def create(type, payload, params = {})
      result = client.backend[ "#{routes[:registered][type.intern]}?#{params_to_s(params)}" ].post payload.to_json, { :content_type => :json, :accept => :json }
      get JSON.parse( result )["uri"]
    end

    def delete(payload)
      JSON.parse ( client.backend[payload["uri"]].delete )
    end

    # this should be less opinionated about paging
    def get(path, params = {})
      result = JSON.parse( client.backend["#{path}?#{params_to_s(params)}"].get )
      if params.has_key? :page
        results = result["results"]
        while result["this_page"] != result["last_page"] do
          params[:page] += 1
          result = JSON.parse( client.backend["#{path}?#{params_to_s(params)}"].get )
          results.concat result["results"]
        end
      else
        results = result
      end
      results
    end

    def merge(payload1, payload2)
      payload1.deep_merge payload2
    end

    # check status
    def update(payload, params = {})
      result = client.backend[ "#{payload["uri"]}?#{params_to_s(params)}" ].post payload.to_json, { :content_type => :json, :accept => :json }
      get JSON.parse( result )["uri"]
    end

    ##########

    # filename is the type
    def template_for(type)
      templates[type]
    end

    def view_context
      { "uri" => client.backend.url } # parse fully
    end

    private

    # endpoints for creating [post] and getting objects
    def routes
      {
        registered: {
          batch_import: "batch_import",
          repository: "repositories",
          repository_with_agent: "repositories/with_agent",
          user: "users",
        }
      }
    end

    ########## HELPERS

    def params_to_s(params)
      params.to_a.map { |x| "#{x[0]}=#{x[1]}" }.join("&")
    end

    def path_to_templates
      File.join(File.dirname(File.expand_path(__FILE__)), 'templates')
    end

  end # CLIENT

end
