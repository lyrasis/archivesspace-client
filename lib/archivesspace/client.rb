# frozen_string_literal: true

require 'dry/cli'
require 'httparty'
require 'json'
require 'nokogiri'

# mixins required first
require 'archivesspace/client/pagination'
require 'archivesspace/client/task'

require 'archivesspace/client/client'
require 'archivesspace/client/configuration'
require 'archivesspace/client/request'
require 'archivesspace/client/response'
require 'archivesspace/client/template'
require 'archivesspace/client/version'

# cli
require 'archivesspace/client/cli/exec'
require 'archivesspace/client/cli/version'
require 'archivesspace/client/cli' # load the registry last

module ArchivesSpace
  class ConnectionError < RuntimeError; end

  class ContextError    < RuntimeError; end

  class RepositoryIdError < RuntimeError; end

  class ParamsError     < RuntimeError; end

  class RequestError    < RuntimeError; end
end
