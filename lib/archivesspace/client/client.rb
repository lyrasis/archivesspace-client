# frozen_string_literal: true

module ArchivesSpace
  class Client
    include Pagination
    include Task
    attr_accessor :token
    attr_reader   :config

    def initialize(config = Configuration.new)
      raise 'Invalid configuration object' unless config.is_a? ArchivesSpace::Configuration

      @config = config
      @token  = nil
    end

    def backend_version
      get 'version'
    end

    def get(path, options = {})
      request 'GET', path, options
    end

    def post(path, payload, params = {})
      request 'POST', path, { body: payload, query: params }
    end

    def put(path, payload, params = {})
      request 'PUT', path, { body: payload, query: params }
    end

    def delete(path)
      request 'DELETE', path
    end

    # Scoping requests
    def repository(id)
      if id.nil?
        use_global_repository
        return
      end

      begin
        Integer(id)
      rescue StandardError
        raise RepositoryIdError, "Invalid Repository id: #{id}"
      end

      @config.base_repo = "repositories/#{id}"
    end

    def use_global_repository
      @config.base_repo = ''
    end

    private

    def request(method, path, options = {})
      sleep config.throttle
      options[:headers] = { 'X-ArchivesSpace-Session' => token } if token
      result = Request.new(config, method, path, options).execute
      Response.new result
    end
  end
end
