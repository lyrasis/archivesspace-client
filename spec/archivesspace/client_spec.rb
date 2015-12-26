require 'spec_helper'

describe ArchivesSpace::Client do

  let(:client) { ArchivesSpace::Client.new }
  let(:login)  { -> { client.login } }

  describe "Configuration" do

    it 'will use the default configuration if none is provided' do
      client = ArchivesSpace::Client.new
      expect(client.config.base_uri).to eq DEFAULT_BASE_URI
    end

    it 'will raise an error if supplied configuration is of invalid type' do
      expect{ ArchivesSpace::Client.new({ base_uri: CUSTOM_BASE_URI }) }.to raise_error(RuntimeError)
    end

    it 'will allow a configuration object to be provided' do
      client = ArchivesSpace::Client.new(ArchivesSpace::Configuration.new({ base_uri: CUSTOM_BASE_URI }))
      expect(client.config.base_uri).to eq CUSTOM_BASE_URI
    end

  end

  describe "Version information" do

    it 'has a version number' do
      expect(ArchivesSpace::Client::VERSION).not_to be nil
    end

    it "can retrieve the backend version info" do
      VCR.use_cassette('backend_version') do
        login.call
        response = client.get "version"
        expect(response.status_code).to eq(200)
        expect(response.body).to match(/ArchivesSpace \(.*\)/)
      end
    end

  end

end