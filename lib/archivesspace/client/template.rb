module ArchivesSpace

  module Template

    def self.list
      []
    end

    def self.process_template(template, data)
      t = ERB.new(self.read_template(template))
      r = t.result(binding).gsub(/\n+/,"\n")
      JSON.parse(r)
    end

    def self.read_template(file)
      File.read("#{self.templates_path}/#{file.to_s}.json.erb")
    end

    def self.templates_path
      File.join(File.dirname(File.expand_path(__FILE__)), 'templates')
    end

  end

end