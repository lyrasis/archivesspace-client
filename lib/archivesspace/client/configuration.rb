# frozen_string_literal: true

module ArchivesSpace
  class Configuration
    def defaults
      {
        base_uri: 'http://localhost:8089',
        base_repo: '',
        debug: false,
        username: 'admin',
        password: 'admin',
        page_size: 50,
        throttle: 0,
        verify_ssl: true
      }
    end

    def initialize(settings = {})
      settings = defaults.merge(settings)
      settings.each do |property, value|
        next unless defaults.keys.include? property

        instance_variable_set("@#{property}", value)
        self.class.send(:attr_accessor, property)
      end
    end
  end
end
