# frozen_string_literal: true

module ArchivesSpace
  class Client
    module CLI
      # ArchivesSpace::Client::CLI::Version prints version
      class Version < Dry::CLI::Command
        desc 'Print ArchivesSpace Client version'

        def call(*)
          puts ArchivesSpace::Client::VERSION
        end
      end
    end
  end
end
