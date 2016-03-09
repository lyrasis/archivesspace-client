module ArchivesSpace

  class Request
    include HTTParty
    attr_reader :config, :headers, :method, :path, :options

    def default_headers(method = :get)
      headers = {
        delete: {},
        get: {},
        post: {
          "Content-Type" => "application/json",
          "Content-Length" => "nnnn",
        },
        put: {
          "Content-Type" => "application/json",
          "Content-Length" => "nnnn",
        }
      }
      headers[method]
    end

    def initialize(config, method = "GET", path = "", options = {})
      @config  = config
      @method  = method.downcase.to_sym
      @path    = path

      @options = options
      @options[:headers]    = options[:headers] ? default_headers(@method).merge(options[:headers]) : default_headers(@method)
      @options[:verify]     = config.verify_ssl
      @options[:query]      = {} unless options.has_key? :query

      base_uri = (config.base_repo.nil? or config.base_repo.empty?) ? config.base_uri : "#{config.base_uri}/#{config.base_repo}"
      self.class.base_uri base_uri
      # self.class.default_params abc: 123
    end

    def execute
      self.class.send method, "/#{path}", options
    end

  end

end
