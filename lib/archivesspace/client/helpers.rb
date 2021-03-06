# frozen_string_literal: true

# needed for roundtrip hash merging
class ::Hash
  def deep_merge(second)
    merger = proc { |_key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    merge(second, &merger)
  end
end

module ArchivesSpace
  module Helpers
    def accessions(options = {})
      all('accessions', options)
    end

    def all(path, options = {})
      Enumerator.new do |yielder|
        page = 1
        unlimited_listing = false
        loop do
          options[:query] ||= {}
          options[:query][:page] = page
          result = get(path, options)
          results = []

          if result.parsed.respond_to?(:key) && result.parsed.key?('results')
            results = result.parsed['results']
          else
            results = result.parsed
            unlimited_listing = true
          end

          if results.any?
            results.each do |i|
              yielder << i
            end
            raise StopIteration if unlimited_listing

            page += 1
          else
            raise StopIteration
          end
        end
      end.lazy
    end

    def backend_version
      get 'version'
    end

    # def batch_import(payload, params = {})
    #   # TODO: create "batch_import", payload, params
    # end

    def digital_objects(options = {})
      all('digital_objects', options)
    end

    def groups(options = {})
      all('groups', options)
    end

    def group_user_assignment(users_with_roles)
      updated = []
      groups.each do |group|
        group = get("groups/#{uri_to_id(group['uri'])}").parsed
        update = false

        users_with_roles.each do |user, roles|
          # should the user still belong to this group?
          if group['member_usernames'].include?(user)
            unless roles.include? group['group_code']
              group['member_usernames'].delete user
              update = true
            end
          # should the user be added to this group?
          elsif roles.include? group['group_code']
            group['member_usernames'] << user
            update = true
          end
        end

        next unless update

        response = post("/groups/#{uri_to_id(group['uri'])}", group.to_json)
        updated << response
      end
      updated
    end

    def login
      username = config.username
      password = config.password
      result = request('POST', "/users/#{username}/login", { query: { password: password } })
      unless result.parsed['session']
        raise ConnectionError, "Failed to connect to ArchivesSpace backend as #{username} #{password}"
      end

      @token = result.parsed['session']
      self
    end

    def password_reset(username, password)
      user = all('users').find { |u| u['username'] == username }
      raise RequestError, user.status unless user

      post(user['uri'], user.to_json, { password: password })
    end

    def repositories(options = {})
      all('repositories', options)
    end

    def repositories_with_agent; end

    def resources(options = {})
      all('resources', options)
    end

    # def search(params)
    #   # TODO: get "search", params
    # end

    def uri_to_id(uri)
      uri.split('/').last
    end

    def users(options = {})
      all('users', options)
    end
  end
end
