# frozen_string_literal: true

module ArchivesSpace
  module Template
    def self.list
      []
    end

    def self.process_template(template, data)
      t = ERB.new(read_template(template))
      r = t.result(binding).gsub(/\n+/, "\n")
      JSON.parse(r)
    end

    def self.read_template(file)
      File.read("#{templates_path}/#{file}.json.erb")
    end

    def self.templates_path
      File.join(File.dirname(File.expand_path(__FILE__)), 'templates')
    end
  end
end
