# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "archivesspace/client"

# usage: ruby examples/upload_ead.rb path/to/ead.xml
path = ARGV.fetch(0) { abort "usage: ruby #{$PROGRAM_NAME} path/to/ead.xml" }

# official sandbox, config boilerplate
config = ArchivesSpace::Configuration.new(
  {
    base_uri: "https://test.archivesspace.org/staff/api",
    username: "admin",
    password: "admin",
    page_size: 50,
    throttle: 0,
    verify_ssl: false
  }
)

client = ArchivesSpace::Client.new(config).login

job = {
  jsonmodel_type: "job",
  job: {
    jsonmodel_type: "import_job",
    import_type: "ead_xml",
    filenames: [File.basename(path)]
  }
}

client.repository 2 do
  response = File.open(path) do |file|
    client.post_multipart("jobs_with_files", {job: job.to_json, files: [file]})
  end
  abort "upload failed (#{response.status_code}): #{response.body}" unless
    response.status_code == 200

  job_id = response.parsed["id"]
  puts "created import job #{job_id}"

  # poll until the import finishes, but not for more than ~60s
  status = nil
  30.times do
    status = client.get("jobs/#{job_id}").parsed["status"]
    puts "status: #{status}"
    break if %w[completed failed canceled].include?(status)

    sleep 2
  end

  puts client.get("jobs/#{job_id}/log").body
end
