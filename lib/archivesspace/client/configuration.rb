# frozen_string_literal: true

module ArchivesSpace
  class Configuration
    attr_accessor :base_uri, :base_repo, :debug, :username, :password,
      :page_size, :throttle, :verify_ssl, :timeout

    DEFAULTS = {
      base_uri: "http://localhost:8089",
      base_repo: "",
      debug: false,
      username: "admin",
      password: "admin",
      page_size: 50,
      throttle: 0,
      verify_ssl: true,
      timeout: 60
    }.freeze

    def initialize(settings = {})
      DEFAULTS.merge(settings).each do |property, value|
        next unless DEFAULTS.key?(property)

        send(:"#{property}=", value)
      end
    end
  end
end
