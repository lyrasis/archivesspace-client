# frozen_string_literal: true

module ArchivesSpace
  class Response
    attr_reader :result, :parsed, :body, :headers, :status, :status_code

    def initialize(result)
      @result      = result
      @parsed      = result.parsed_response
      @body        = result.body
      @headers     = result.headers
      @status      = result.response
      @status_code = result.code.to_i
    end
  end
end
