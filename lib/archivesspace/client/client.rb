# frozen_string_literal: true

module ArchivesSpace
  class Client
    include Helpers
    attr_accessor :token
    attr_reader   :config

    def initialize(config = Configuration.new)
      raise 'Invalid configuration object' unless config.is_a? ArchivesSpace::Configuration

      @config = config
      @token  = nil
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

    private

    def request(method, path, options = {})
      sleep config.throttle
      options[:headers] = { 'X-ArchivesSpace-Session' => token } if token
      result = Request.new(config, method, path, options).execute
      Response.new result
    end
  end
end
