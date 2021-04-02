# frozen_string_literal: true

require 'httparty'
require 'json'
require 'nokogiri'

# mixins required first
require 'archivesspace/client/helpers'

require 'archivesspace/client/client'
require 'archivesspace/client/configuration'
require 'archivesspace/client/request'
require 'archivesspace/client/response'
require 'archivesspace/client/template'
require 'archivesspace/client/version'

module ArchivesSpace
  class ConnectionError < RuntimeError; end
  class ContextError    < RuntimeError; end
  class ParamsError     < RuntimeError; end
  class RequestError    < RuntimeError; end
end
