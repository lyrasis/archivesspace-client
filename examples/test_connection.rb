$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'awesome_print'
require 'archivesspace/client'

# default client connection: localhost:8089, admin, admin
client = ArchivesSpace::Client.new.login

# todo ... example of assignment using CSV
