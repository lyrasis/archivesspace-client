# frozen_string_literal: true

require 'spec_helper'

describe ArchivesSpace::Configuration do
  it 'uses the default profile for configuration settings' do
    config = ArchivesSpace::Configuration.new
    expect(config.base_uri).to eq DEFAULT_BASE_URI
  end

  it 'allows configuration settings to be provided' do
    config = ArchivesSpace::Configuration.new({
                                                base_uri: CUSTOM_BASE_URI
                                              })
    expect(config.base_uri).to eq CUSTOM_BASE_URI
  end

  it 'allows the configuration properties to be updated' do
    config = ArchivesSpace::Configuration.new
    config.base_uri = CUSTOM_BASE_URI
    expect(config.base_uri).to eq CUSTOM_BASE_URI
  end

  it 'ignores unrecognized configuration properties' do
    config = ArchivesSpace::Configuration.new({ xyz: 123 })
    expect { config.xyz }.to raise_error(NoMethodError)
  end
end
