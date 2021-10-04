# frozen_string_literal: true

require 'spec_helper'

describe ArchivesSpace::Client do
  let(:client) { ArchivesSpace::Client.new }
  let(:login)  { -> { client.login } }

  describe 'Configuration' do
    it 'will use the default configuration if none is provided' do
      client = ArchivesSpace::Client.new
      expect(client.config.base_uri).to eq DEFAULT_BASE_URI
    end

    it 'will raise an error if supplied configuration is of invalid type' do
      expect { ArchivesSpace::Client.new({ base_uri: CUSTOM_BASE_URI }) }.to raise_error(RuntimeError)
    end

    it 'will allow a configuration object to be provided' do
      client = ArchivesSpace::Client.new(ArchivesSpace::Configuration.new({ base_uri: CUSTOM_BASE_URI }))
      expect(client.config.base_uri).to eq CUSTOM_BASE_URI
    end
  end

  describe 'Repository scoping' do
    it 'will set the repository with an integer id' do
      client = ArchivesSpace::Client.new
      client.repository 2
      expect(client.config.base_repo).to eq 'repositories/2'
    end

    it 'will set the repository with a string id cast to integer' do
      client = ArchivesSpace::Client.new
      client.repository '2'
      expect(client.config.base_repo).to eq 'repositories/2'
    end

    it 'will fail if the id cannot be cast to integer' do
      client = ArchivesSpace::Client.new
      expect { client.repository('xyz') }.to raise_error(
        ArchivesSpace::RepositoryIdError
      )
    end

    it 'will use the global repo if repository is passed nil' do
      client = ArchivesSpace::Client.new
      client.repository 2
      client.repository nil
      expect(client.config.base_repo).to eq ''
    end

    it 'will use the global repo when the method is called' do
      client = ArchivesSpace::Client.new
      client.repository 2
      client.use_global_repository
      expect(client.config.base_repo).to eq ''
    end
  end

  describe 'Pagination' do
    it 'will have a method for defined paginated record types' do
      client = ArchivesSpace::Client.new
      ArchivesSpace::Pagination::ENDPOINTS.each do |e|
        next if e.match?('/')

        expect(client.respond_to?(e.to_sym)).to be true
      end
    end

    it 'will have a method for defined paginated record types with multipart path' do
      client = ArchivesSpace::Client.new
      expect(client.respond_to?(:people)).to be true
    end
  end

  describe 'Version information' do
    it 'has a version number' do
      expect(ArchivesSpace::Client::VERSION).not_to be nil
    end

    it 'can retrieve the backend version info' do
      VCR.use_cassette('backend_version') do
        login.call
        response = client.get 'version'
        expect(response.status_code).to eq(200)
        expect(response.body).to match(/ArchivesSpace \(.*\)/)
      end
    end
  end
end
