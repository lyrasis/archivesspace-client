#!/usr/bin/env ruby
require "archivesspace/client"
require "json"
require "pp"

host             = "localhost"
backend_port     = "8089" 
backend          = ArchivesSpace::Client.new( { site: "http://#{host}:#{backend_port}" } )
backend.user     = 'admin'
backend.password = 'admin'
backend.login

# will fail silently after 1st run but safe as retrieved below
repo = backend.create(:repository, { repository: { repo_code: 'EXAMPLE', name: 'Example Archive' } })

_p = {}
_g = {}

ver    = backend.version
repo   = backend.repositories.find { |r| r.name =~ /example/i }
perms  = backend.permissions "all"
groups = backend.groups(repo)

perms.each do |p|
  _p[p.permission_code] = {} unless _p.has_key? p.permission_code
  _p[p.permission_code][:description] = p.description.split(":")[0]
  _p[p.permission_code][:level]       = p.level
  _p[p.permission_code][:uri]         = p.uri
end

groups.each do |g|
  _g[g.group_code] = {} unless _g.has_key? g.group_code
  _g[g.group_code][:description] = g.description.split(":")[0]
  _g[g.group_code][:permissions] = g.grants_permissions
end

puts

puts "#{ver} permissions and groups"

puts

_p.each do |code, attributes|
  puts "#{code}\t#{attributes[:description]}\t#{attributes[:level]}"
end

puts

_g.each do |code, attributes|
  puts code
  puts "\t#{attributes[:description]}"
  attributes[:permissions].each do |p|
    puts "\t\t#{_p[p][:description]}"
  end
  puts
end

__END__

