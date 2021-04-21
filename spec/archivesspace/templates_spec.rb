# frozen_string_literal: true

require 'spec_helper'

describe ArchivesSpace::Template do
  it 'can list the default templates' do
    templates = ArchivesSpace::Template.list
    expect(templates).to_not be_empty
    expect(templates).to include(/repository_with_agent.*erb/)
  end

  it 'can change the path when template envvar is set' do
    expect(ArchivesSpace::Template.templates_path).to match(
      /#{File.join('lib', 'archivesspace', 'client', 'templates')}/
    )
    ENV['ARCHIVESSPACE_CLIENT_TEMPLATES_PATH'] = '/path/to/nowhere'
    expect(ArchivesSpace::Template.templates_path).to eq '/path/to/nowhere'
    ENV.delete('ARCHIVESSPACE_CLIENT_TEMPLATES_PATH')
  end

  it 'can process a template' do
    data = { repo_code: 'ABC', name: 'ABC Archive', agent_contact_name: 'ABC Admin' }
    json = JSON.parse(ArchivesSpace::Template.process(:repository_with_agent, data))
    expect(json['repository']['repo_code']).to eq data[:repo_code]
  end
end