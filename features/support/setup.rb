# frozen_string_literal: true

require 'aruba/cucumber'
require 'json_spec/cucumber'
require 'capybara_discoball'

def last_json
  last_command_started.output
end
