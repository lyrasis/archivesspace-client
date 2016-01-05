# needed for roundtrip hash merging
class ::Hash
  def deep_merge(second)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    self.merge(second, &merger)
  end
end

module ArchivesSpace

  module Helpers

    def accessions(options = {}, &block)
      records = all('accessions', options) do |record|
        yield record if block_given?
      end
      records
    end

    def all(path, options = {}, &block)
      all    = []
      format = options.delete(:format)
      # options[:headers] -- add xml headers if format

      result = get(path, options.merge({ query: { all_ids: true } } ))
      ap result
      raise RequestError.new result.status if result.status_code != 200
      result.parsed.each do |id|
        path_with_id = format ? "#{format}/#{id}.xml" : "#{path}/#{id}"
        result = get(path_with_id, options)
        raise RequestError.new result.status if result.status_code != 200
        record = format ? Nokogiri::XML(result.body).to_xml : result.parsed
        yield record if block_given?
        all << record
      end
      all
    end

    def backend_version
      get "version"
    end

    def batch_import(payload, params = {})
      # create "batch_import", payload, params
    end

    def digital_object_to_xml(digital_object, format = "dublin_core")
      id   = digital_object["uri"].split("/")[-1]
      path = "digital_objects/#{format}/#{id}.xml"
      get_xml path
    end

    def digital_objects(format = nil, options = {}, &block)
      path    = "digital_objects"
      format  = format ? "#{path}/#{format}" : nil
      records = all(path, options.merge({ format: format })) do |record|
        yield record if block_given?
      end
      records
    end

    def groups
      #
    end

    def group_user_assignment(users_with_roles, params = { with_members: true })
      # updated = []
      # groups.each do |group|
      #   changed = false

      #   users_with_roles.each do |user, roles|
      #     if roles.include? group["group_code"]
      #       unless group["member_usernames"].include? user
      #         group["member_usernames"] << user
      #         changed = true
      #       end
      #     else
      #       if group["member_usernames"].include? user
      #         group["member_usernames"].delete user
      #         changed = true
      #       end
      #     end
      #   end

      #   if changed
      #     updated << update( group, params )
      #   end
        
      #   sleep 1 # moderate requests
      # end
      # updated
    end

    def login
      username, password = config.username, config.password
      result = request('POST', "/users/#{username}/login", { query: { password: password } })
      raise ConnectionError.new "Failed to connect to ArchivesSpace backend as #{username} #{password}" unless result.parsed["session"]
      @token = result.parsed["session"]
      self
    end

    def password_reset(username, password)
      user = all('users').find { |u| u["username"] == username }
      raise RequestError.new user.status unless user
      post(user["uri"], user, { password: password })
    end

    def repositories
      records = get('repositories').parsed.each do |record|
        yield record if block_given?
      end
      records
    end

    def repositories_with_agent
      #
    end

    def resource_to_xml(resource, format = "ead")
      id   = resource["uri"].split("/")[-1]
      path = format == "ead" ? "resource_descriptions/#{id}.xml" : "resources/#{format}/#{id}.xml"
      get_xml path
    end

    def resources(format = nil, options = {}, &block)
      path = 'resources'
      # the api is inconsistent with the path structure for resource ead (and pdf)
      if format
        if format =~ /(ead|pdf)/
          format = "resource_descriptions"
        else
          format = "#{path}/#{format}"
        end
      end
      records = all(path, options.merge({ format: format })) do |record|
        yield record if block_given?
      end
      records
    end

    def search(params)
      # get "search", params
    end

    def users
      records = all('users') do |record|
        yield record if block_given?
      end
      records
    end

    private

    def get_xml(path)
      # add xml headers
      response = get(path)
      raise RequestError.new path unless response.status_code == 200
      Nokogiri::XML(response.body).to_xml
    end

  end

end