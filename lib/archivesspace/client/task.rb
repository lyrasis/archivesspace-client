# frozen_string_literal: true

module ArchivesSpace
  # Perform specific API tasks
  module Task
    # def batch_import(payload, params = {})
    #   # TODO: create "batch_import", payload, params
    # end

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
      username  = config.username
      password  = config.password
      base_repo = config.base_repo
      use_global_repository # ensure we're in the global scope to login
      result = request('POST', "/users/#{username}/login", { query: { password: password } })
      unless result.parsed['session']
        raise ConnectionError, "API client login failed as user [#{username}], check username and password are correct"
      end

      config.base_repo = base_repo # reset repo as set by the cfg
      @token = result.parsed['session']
      self
    end

    def password_reset(username, password)
      user = all('users').find { |u| u['username'] == username }
      raise RequestError, user.status unless user

      post(user['uri'], user.to_json, { password: password })
    end

    # def search(params)
    #   # TODO: get "search", params
    # end

    private

    def uri_to_id(uri)
      uri.split('/').last
    end
  end
end
