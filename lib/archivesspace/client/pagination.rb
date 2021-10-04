# frozen_string_literal: true

module ArchivesSpace
  # Handle API Pagination using enumerator
  module Pagination
    # TODO: get via lookup of endpoints that support pagination? (nice-to-have)
    ENDPOINTS = %w[
      accessions
      agents/corporate_entities
      agents/families
      agents/people
      agents/software
      archival_objects
      digital_objects
      groups
      repositiories
      resources
      subjects
      users
    ]

    ENDPOINTS.each do |endpoint|
      method_name = endpoint.split('/').last # remove prefix
      define_method(method_name) do |options = {}|
        all(endpoint, options)
      end
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
  end
end
