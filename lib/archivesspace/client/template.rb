# frozen_string_literal: true

module ArchivesSpace
  module Template
    def self.list
      Dir.glob ["*"], base: File.join(templates_path)
    end

    def self.process(template, data)
      processor = File.extname(template).delete(".").camelize
      processor = Object.const_get("ArchivesSpace::Template::#{processor}")
      processor.new(template, data).process
    end

    def self.templates_path
      ENV.fetch(
        "ARCHIVESSPACE_CLIENT_TEMPLATES_PATH",
        File.join(File.dirname(File.expand_path(__FILE__)), "templates")
      )
    end

    class Processor
      attr_reader :template, :data

      def initialize(template, data)
        @template = template
        @data = data

        validate_template
      end

      def extension
        raise "Not implemented"
      end

      def read_template
        File.read(File.join(ArchivesSpace::Template.templates_path, template))
      end

      def validate_template
        raise "Invalid template" unless File.extname(template).end_with? extension
      end
    end

    class Erb < Processor
      def extension
        ".erb"
      end

      def process
        t = ERB.new(read_template)
        r = t.result(binding).squeeze("\n")
        JSON.parse(r)
      end
    end

    class Jbuilder < Processor
      def extension
        ".jbuilder"
      end

      def process
        ::Jbuilder.new do |json|
          eval(read_template, binding) # standard:disable Security/Eval
        end.attributes!
      end
    end
  end
end
