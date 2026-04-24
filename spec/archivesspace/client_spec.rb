# frozen_string_literal: true

require "spec_helper"

describe ArchivesSpace::Client do
  let(:client) { ArchivesSpace::Client.new }

  describe "Configuration" do
    it "will use the default configuration if none is provided" do
      expect(client.config.base_uri).to eq DEFAULT_BASE_URI
    end

    it "will raise an error if supplied configuration is of invalid type" do
      expect { ArchivesSpace::Client.new({base_uri: CUSTOM_BASE_URI}) }.to raise_error(ArchivesSpace::ConfigurationError)
    end

    it "will allow a configuration object to be provided" do
      client = ArchivesSpace::Client.new(ArchivesSpace::Configuration.new({base_uri: CUSTOM_BASE_URI}))
      expect(client.config.base_uri).to eq CUSTOM_BASE_URI
    end
  end

  describe "Login" do
    it "sends the login request at global scope even when a repo context is set" do
      client.repository 2
      expect(ArchivesSpace::Request).to receive(:new)
        .with(nil, client.config, "POST", "/users/admin/login", anything)
        .and_wrap_original do |_orig, *_args|
          double("request", execute: double("response", parsed: {"session" => "token"}, status_code: 200))
        end
      client.login
    end

    it "restores the previous repo context after login" do
      client.repository 2
      allow(ArchivesSpace::Request).to receive(:new).and_return(
        double("request", execute: double("response", parsed: {"session" => "token"}, status_code: 200))
      )
      client.login
      expect(client.context).to eq "repositories/2"
    end

    it "raises AuthenticationError and restores context when credentials are rejected" do
      client.repository 2
      allow(ArchivesSpace::Request).to receive(:new).and_return(
        double("request", execute: double("response", parsed: {}, status_code: 403))
      )
      expect { client.login }.to raise_error(ArchivesSpace::AuthenticationError, /status 403/)
      expect(client.context).to eq "repositories/2"
    end

    it "raises AuthenticationError for a real 403 response (VCR)" do
      bad_client = ArchivesSpace::Client.new(
        ArchivesSpace::Configuration.new(password: "wrong")
      )
      VCR.use_cassette("login_failure") do
        expect { bad_client.login }.to raise_error(
          ArchivesSpace::AuthenticationError, /admin.*status 403/
        )
      end
    end
  end

  describe "Pagination" do
    it "will have a method for defined paginated record types" do
      ArchivesSpace::Pagination::ENDPOINTS.each do |e|
        next if e.match?("/")

        expect(client.respond_to?(e.to_sym)).to be true
      end
    end

    it "will have a method for defined paginated record types with multipart path" do
      expect(client.respond_to?(:people)).to be true
    end

    it "will pass page_size from configuration to the query" do
      response = double("response", parsed: {"results" => []})
      allow(client).to receive(:get).and_return(response)
      client.all("resources").first
      expect(client).to have_received(:get).with("resources", hash_including(query: hash_including(page_size: 50)))
    end
  end

  describe "Password reset" do
    it "will raise an error if the user is not found" do
      allow(client).to receive(:all).with("users").and_return([].lazy)
      expect { client.password_reset("nonexistent", "newpass") }.to raise_error(
        ArchivesSpace::RequestError, "User not found: nonexistent"
      )
    end
  end

  describe "Repository scoping" do
    it "will set the context with an integer id" do
      client.repository 2
      expect(client.context).to eq "repositories/2"
    end

    it "will set the context with a string id cast to integer" do
      client.repository "2"
      expect(client.context).to eq "repositories/2"
    end

    it "will fail if the id cannot be cast to integer" do
      expect { client.repository("xyz") }.to raise_error(
        ArchivesSpace::RepositoryIdError
      )
    end

    it "will fail if the id is not a valid type" do
      expect { client.repository([]) }.to raise_error(
        ArchivesSpace::RepositoryIdError
      )
    end

    it "will clear the context when passed nil" do
      client.repository 2
      client.repository nil
      expect(client.context).to be_nil
    end

    it "will clear the context when use_global_repository is called" do
      client.repository 2
      client.use_global_repository
      expect(client.context).to be_nil
    end

    it "scopes the context to a block and restores afterwards" do
      client.repository(2) do
        expect(client.context).to eq "repositories/2"
      end
      expect(client.context).to be_nil
    end

    it "restores the previous context when nested" do
      client.repository 2
      client.repository(3) do
        expect(client.context).to eq "repositories/3"
      end
      expect(client.context).to eq "repositories/2"
    end

    it "restores the context even if the block raises" do
      expect { client.repository(2) { raise "boom" } }.to raise_error("boom")
      expect(client.context).to be_nil
    end

    it "does not rebrand ArgumentError raised from within the block" do
      expect {
        client.repository(2) { raise ArgumentError, "from caller" }
      }.to raise_error(ArgumentError, "from caller")
    end
  end

  describe "Requests" do
    it "will have an identifiable user agent" do
      request = ArchivesSpace::Request.new(nil, client.config)
      expect(request.options[:headers]["User-Agent"]).to eq "#{ArchivesSpace::Client::NAME}/#{ArchivesSpace::Client::VERSION}"
    end

    it "does not mutate the caller's options hash" do
      opts = {query: {foo: "bar"}, headers: {"X-Custom" => "1"}}
      caller_opts = Marshal.load(Marshal.dump(opts))
      ArchivesSpace::Request.new(nil, client.config, "GET", "resources", opts)
      expect(opts).to eq(caller_opts)
    end

    it "does not mutate the caller's options hash when injecting the session token" do
      client.token = "abc123"
      opts = {query: {foo: "bar"}}
      caller_opts = Marshal.load(Marshal.dump(opts))
      allow(ArchivesSpace::Request).to receive(:new).and_return(
        double("request", execute: double("response", status_code: 200))
      )
      client.get("resources", opts)
      expect(opts).to eq(caller_opts)
    end
  end

  describe "URL construction" do
    let(:config) { ArchivesSpace::Configuration.new(base_uri: "http://localhost:8089") }

    it "uses the bare base_uri when context is nil" do
      ArchivesSpace::Request.new(nil, config, "GET", "repositories")
      expect(ArchivesSpace::Request.base_uri).to eq "http://localhost:8089"
    end

    it "appends a repository context to the base_uri" do
      ArchivesSpace::Request.new("repositories/2", config, "GET", "resources")
      expect(ArchivesSpace::Request.base_uri).to eq "http://localhost:8089/repositories/2"
    end

    it "preserves a path prefix in base_uri when context is nil" do
      config.base_uri = "https://example.org/staff/api"
      ArchivesSpace::Request.new(nil, config, "GET", "repositories")
      expect(ArchivesSpace::Request.base_uri).to eq "https://example.org/staff/api"
    end

    it "preserves a path prefix in base_uri when scoped to a repository" do
      config.base_uri = "https://example.org/staff/api"
      ArchivesSpace::Request.new("repositories/2", config, "GET", "resources")
      expect(ArchivesSpace::Request.base_uri).to eq "https://example.org/staff/api/repositories/2"
    end
  end

  describe "Version information" do
    it "has a version number" do
      expect(ArchivesSpace::Client::VERSION).not_to be nil
    end

    it "can retrieve the backend version info" do
      VCR.use_cassette("backend_version") do
        client.login
        response = client.get "version"
        expect(response.status_code).to eq(200)
        expect(response.body).to match(/ArchivesSpace \(.*\)/)
      end
    end
  end
end
