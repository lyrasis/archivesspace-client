require 'httparty'
require 'json'
require 'nokogiri'

# mixins required first
require "archivesspace/client/helpers"

require "archivesspace/client/client"
require "archivesspace/client/configuration"
require "archivesspace/client/request"
require "archivesspace/client/response"
require "archivesspace/client/template"
require "archivesspace/client/version"

module ArchivesSpace

  class ConnectionError < Exception ; end
  class ContextError    < Exception ; end
  class ParamsError     < Exception ; end
  class RequestError    < Exception ; end

end