# frozen_string_literal: true

require "spec_helper"

describe ArchivesSpace::Template do
  it "can list the default templates" do
    templates = ArchivesSpace::Template.list
    expect(templates).to_not be_empty
    expect(templates).to include(/repository_with_agent.*erb/)
  end

  it "can change the path when template envvar is set" do
    expect(ArchivesSpace::Template.templates_path).to match(
      /#{File.join('lib', 'archivesspace', 'client', 'templates')}/
    )
    ENV["ARCHIVESSPACE_CLIENT_TEMPLATES_PATH"] = "/path/to/nowhere"
    expect(ArchivesSpace::Template.templates_path).to eq "/path/to/nowhere"
    ENV.delete("ARCHIVESSPACE_CLIENT_TEMPLATES_PATH")
  end

  it "can process an erb template" do
    data = {repo_code: "ABC", name: "ABC Archive", agent_contact_name: "ABC Admin"}
    json = JSON.parse(ArchivesSpace::Template.process(:repository_with_agent, data))
    expect(json["repository"]["repo_code"]).to eq data[:repo_code]
  end

  it "can process a jbuilder template" do
    data = {"title" => "Title", "object_number" => "001.001", "description_level" => "collection"}
    json = JSON.parse(ArchivesSpace::Template.process(:resource, data))
    expect(json["id_0"]).to eq data["object_number"]
  end
end
