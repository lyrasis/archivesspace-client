# frozen_string_literal: true

module ArchivesSpace
  class Request
    include HTTParty
    attr_reader :config, :headers, :method, :path, :options

    def default_headers(method = :get)
      headers = {
        delete: {},
        get: {},
        post: {
          'Content-Type' => 'application/json',
          'Content-Length' => 'nnnn'
        },
        put: {
          'Content-Type' => 'application/json',
          'Content-Length' => 'nnnn'
        }
      }
      headers[method]
    end

    def initialize(config, method = 'GET', path = '', options = {})
      @config            = config
      @method            = method.downcase.to_sym
      @path              = path.gsub(%r{^/+}, '')
      @options           = options
      @options[:headers] = options[:headers] ? default_headers(@method).merge(options[:headers]) : default_headers(@method)
      @options[:verify]  = config.verify_ssl
      @options[:query]   = {} unless options.key? :query

      self.class.debug_output($stdout) if @config.debug

      base_uri = config.base_repo&.length&.positive? ? File.join(config.base_uri, config.base_repo) : config.base_uri
      self.class.base_uri base_uri
    end

    def execute
      self.class.send method, "/#{path}", options
    end
  end
end
