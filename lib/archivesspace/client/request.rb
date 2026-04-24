# frozen_string_literal: true

module ArchivesSpace
  class Request
    include HTTParty

    attr_reader :config, :headers, :method, :path, :options

    DEFAULT_HEADERS = {"Content-Type" => "application/json"}.freeze

    def initialize(context, config, method = "GET", path = "", options = {})
      @config = config

      @method = method.downcase.to_sym
      @path = path.gsub(%r{^/+}, "")

      @options = options

      @options[:headers] = DEFAULT_HEADERS.merge(@options.fetch(:headers, {}))
      @options[:headers]["User-Agent"] = "#{Client::NAME}/#{Client::VERSION}"

      @options[:verify] = config.verify_ssl
      @options[:timeout] = config.timeout
      @options[:query] = {} unless options.key? :query

      self.class.debug_output($stdout) if @config.debug
      self.class.base_uri context ? "#{config.base_uri}/#{context}" : config.base_uri
    end

    def execute
      Response.new(self.class.send(method, "/#{path}", options))
    end
  end
end
