# frozen_string_literal: true

module ArchivesSpace
  class Configuration
    attr_accessor :base_uri, :debug, :username, :password,
      :page_size, :throttle, :timeout, :verify_ssl

    DEFAULTS = {
      base_uri: "http://localhost:8089",
      debug: false,
      username: "admin",
      password: "admin",
      page_size: 50,
      throttle: 0,
      timeout: 60,
      verify_ssl: true
    }.freeze

    def initialize(settings = {})
      DEFAULTS.merge(settings).each do |property, value|
        next unless DEFAULTS.key?(property)

        send(:"#{property}=", value)
      end
    end
  end
end
