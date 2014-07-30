module ArchivesSpace

  module Errors
    class ContextError < StandardError
    end

    class ParamsError < StandardError
    end
  end # ERRORS

  module DigitalObjects

    include Errors
    @@context = "repositories"

    def digital_objects(repository, format = nil)
      digital_object_ids = get("#{repository["uri"]}/digital_objects?all_ids=true")
      results = []
      if format
        results = digital_object_ids.map { |o| Nokogiri::XML(client.backend["#{repository["uri"]}/digital_objects/#{format}/#{o}.xml"].get) }
      else
        results = digital_object_ids.map { |o| get "#{repository["uri"]}/digital_objects/#{o}" }
      end
      results
    end

  end

  module Groups

    include Errors
    @@context = "repositories"

    def groups(repository)
      get "#{repository["uri"]}/groups"
    end

    def set_user_groups(repository, users_with_roles, params = { with_members: true })
      updated = []
      groups(repository).each do |group|
        changed = false

        users_with_roles.each do |user, roles|
          if roles.include? group["group_code"]
            unless group["member_usernames"].include? user
              group["member_usernames"] << user
              changed = true
            end
          else
            if group["member_usernames"].include? user
              group["member_usernames"].delete user
              changed = true
            end
          end
        end

        if changed
          updated << update( group, params )
        end
        
        sleep 1 # moderate requests
      end
      updated
    end

  end

  module Import

    include Errors

    def batch_import(payload, params = {})
      create "batch_import", payload, params
    end

  end

  module Repository

    include Errors

    def repositories
      get routes[:registered][:repository]
    end

    def repositories_with_agent
      results = get routes[:registered][:repository]
      result = results.inject([]) do |with_agents, repository| 
        id = repository["uri"][-1]
        with_agents << get("repositories/with_agent/#{id}")
      end
      result
    end

  end # REPOSITORY

  module Search

    include Errors

    def search(params)
      get "search", params
    end

  end

  module System

    include Errors

    def version
      get ""
    end

  end # SYSTWM

  module Users

    include Errors

    def users(params = { page: 1 })
      raise ParamsError, "Requires :all_ids, :id_set or :page param" unless [:all_ids, :id_set, :page].any? { |p| params.key? p}
      get "users", params
    end

  end # USERS

end
