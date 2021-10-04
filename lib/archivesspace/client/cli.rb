# frozen_string_literal: true

module ArchivesSpace
  class Client
    module CLI
      extend Dry::CLI::Registry

      def self.client
        cfg = ArchivesSpace::Configuration.new(ArchivesSpace::Client::CLI.find_config)
        ArchivesSpace::Client.new(cfg).login
      end

      def self.find_config
        config = ENV.fetch('ASCLIENT_CFG', File.join(ENV['HOME'], '.asclientrc'))
        raise "Unable to find asclient configuration file at: #{config}" unless File.file?(config)

        JSON.parse(File.read(config), symbolize_names: true)
      end

      register 'exec', Exec, aliases: ['e', '-e']
      register 'version', Version, aliases: ['v', '-v', '--version']
    end
  end
end
