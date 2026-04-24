# frozen_string_literal: true

module ArchivesSpace
  class Client
    include Pagination
    include Task

    attr_accessor :token
    attr_reader :config, :context

    NAME = "ArchivesSpaceClient"
    TOKEN = "X-ArchivesSpace-Session"

    def initialize(config = Configuration.new)
      unless config.is_a? ArchivesSpace::Configuration
        raise ConfigurationError, "expected ArchivesSpace::Configuration, got #{config.class}"
      end

      @config = config
      @context = nil
      @token = nil
    end

    def backend_version
      get "version"
    end

    def get(path, options = {})
      request "GET", path, options
    end

    def post(path, payload, params = {})
      request "POST", path, {body: payload.to_json, query: params}
    end

    def put(path, payload, params = {})
      request "PUT", path, {body: payload.to_json, query: params}
    end

    def delete(path)
      request "DELETE", path
    end

    # Scoping requests
    def repository(id)
      return use_global_repository if id.nil?

      begin
        Integer(id)
      rescue ArgumentError, TypeError
        raise RepositoryIdError, "Invalid Repository id: #{id}"
      end

      new_context = "repositories/#{id}"
      return @context = new_context unless block_given?

      previous = @context
      @context = new_context
      begin
        yield
      ensure
        @context = previous
      end
    end

    def use_global_repository
      @context = nil
    end

    private

    def request(method, path, options = {})
      sleep config.throttle
      options = options.dup
      options[:headers] = {TOKEN => token} if token
      Request.new(context, config, method, path, options).execute
    end
  end
end
