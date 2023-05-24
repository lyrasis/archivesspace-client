# frozen_string_literal: true

module ArchivesSpace
  module Template
    def self.list
      Dir.glob File.join(templates_path, "*.erb")
    end

    def self.find_ext(file)
      if `ls #{templates_path}`.include? "#{file}.json.erb"
        "erb"
      elsif `ls #{templates_path}`.include? "#{file}.json.jbuilder"
        "jbuilder"
      end
    end

    # currently assumes that template name is unique. if two templates have the same
    # basename (ex. resource.json.erb and resource.json.jbuilder), then this would
    # default to the erb template
    def self.process(template, data)
      ext = find_ext(template)
      case ext
      when "erb"
        t = ERB.new(read(template))
        r = t.result(binding).squeeze("\n")
        JSON.parse(r).to_json
      when "jbuilder"
        Jbuilder.encode do |json|
          # safe enough since the tool is self-contained?
          # open to suggestions on how to better process jbuilder
          # template from a file
          eval(read(template), binding)
        end
      end
    end

    def self.read(file)
      ext = find_ext(file)
      case ext
      when "erb"
        File.read("#{templates_path}/#{file}.json.erb")
      when "jbuilder"
        File.read("#{templates_path}/#{file}.json.jbuilder")
      end
    end

    def self.templates_path
      ENV.fetch(
        "ARCHIVESSPACE_CLIENT_TEMPLATES_PATH",
        File.join(File.dirname(File.expand_path(__FILE__)), "templates")
      )
    end
  end
end
