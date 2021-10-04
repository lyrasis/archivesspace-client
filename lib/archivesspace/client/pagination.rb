# frozen_string_literal: true

module ArchivesSpace
  # Handle API Pagination using enumerator
  module Pagination
    def accessions(options = {})
      all('accessions', options)
    end

    def all(path, options = {})
      Enumerator.new do |yielder|
        page = 1
        unlimited_listing = false
        loop do
          options[:query] ||= {}
          options[:query][:page] = page
          result = get(path, options)
          results = []

          if result.parsed.respond_to?(:key) && result.parsed.key?('results')
            results = result.parsed['results']
          else
            results = result.parsed
            unlimited_listing = true
          end

          if results.any?
            results.each do |i|
              yielder << i
            end
            raise StopIteration if unlimited_listing

            page += 1
          else
            raise StopIteration
          end
        end
      end.lazy
    end

    def archival_objects(options = {})
      all('archival_objects', options)
    end

    def digital_objects(options = {})
      all('digital_objects', options)
    end

    def groups(options = {})
      all('groups', options)
    end

    def repositories(options = {})
      all('repositories', options)
    end

    def repositories_with_agent; end

    def resources(options = {})
      all('resources', options)
    end

    def users(options = {})
      all('users', options)
    end
  end
end
