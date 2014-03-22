require "archivesspace/client/version"
require 'json'
require 'pp'
require 'rest-core'

# needed for roundtrip hash merging
class ::Hash
  def deep_merge(second)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    self.merge(second, &merger)
  end
end

# return boolean true only if string is 't' or 'true', otherwise false
class ::String
  def to_boolean
    self == 't' or self == 'true'
  end
end

module ArchivesSpace

  ArchivesSpaceClient = RC::Builder.client do
    use RC::DefaultSite, nil
    use RC::DefaultHeaders, {}
    use RC::JsonResponse, true
    use RC::CommonLogger, method(:puts)
  end

  class Group      < OpenStruct
  end

  class Permission < OpenStruct
  end

  class Repository < OpenStruct
  end

  class Subject    < OpenStruct
  end  

  class User       < OpenStruct
  end  

  class Client
    # Connect to the ArchivesSpace backend

    attr_accessor :client, :user, :password, :token

    ROUTE = {
      repository: '/repositories/with_agent',
      user: '/users',
    }

    def initialize(args = {})
      @client   = ArchivesSpaceClient.new( { site: args[:site] } )
      @user     = args[:user]
      @password = args[:password]
      @session  = 'X-ArchivesSpace-Session'
      @token    = nil
    end

    # create a new object
    def create(type, payload = {}, query = {})
      klass = "ArchivesSpace::#{type.to_s.capitalize}"
      path = ROUTE[type]
      obj = @client.post( path, JSON.generate(payload), query )
      # todo: log obj
      Module.const_get(klass).new(obj)
    end

    # delete an object
    def delete(object)
      @client.delete(object.uri)
    end

    # authenticate a user
    def login
      raise "user and password attributes required" unless @user and @password
      result = @client.post("/users/#{@user}/login", { password: @password })
      @token = result['session']
      @client.headers[@session] = @token
      @token
    end

    # combine / overwrite the elements of x with those in y
    def merge(x, y)
      # raise "FAIL" unless x.class == y.class
      klass  = x.class
      xtmp   = roundtrip(x.to_h)
      ytmp   = roundtrip(y.to_h)
      merged = xtmp.deep_merge(ytmp)
      klass.new( merged )
    end

    def method_missing(name, *args, &block)
      @client.send(name, *args, &block)
    end

    # return the updated object
    def update(object, query = {})
      klass = object.class
      obj = object.to_h
      obj = @client.post( object.uri, JSON.generate(obj), query )
      # todo: log obj
      klass.new( @client.get(obj["uri"]) )
    end

    def version
      @client.get("/version")
    end

    ########## CLASSES

    # return array of groups associated with a repository
    def groups(repository)
      result = @client.get("#{repository.uri}/groups")
      groups = []
      result.each do |group|
        g = @client.get(group["uri"]) # this will include member info
        groups << ArchivesSpace::Group.new(g)
      end
      groups
    end

    def permissions(level = "repository")
      result = @client.get("/permissions", { level: level })
      permissions = []
      result.each { |p| permissions << ArchivesSpace::Permission.new(p) }
      permissions
    end

    # return an array of repositories
    def repositories
      result = @client.get("/repositories")
      repositories = []
      result.each { |r| repositories << ArchivesSpace::Repository.new(r) }
      repositories
    end

    # return an array of repositories with agents
    def repositories_with_agents
      result = @client.get("/repositories")
      repositories = []
      result.each do |r| 
        id = r["uri"].split("/")[-1]
        r = @client.get("/repositories/with_agent/#{id}")
        repositories << ArchivesSpace::Repository.new(r)
      end
      repositories
    end    

    # return an array of subjects
    def subjects
      gather_paged_resources(:subject, "/subjects")
    end

    # return an array of users
    def users
      gather_paged_resources(:user, "/users")
    end

    ########## PRIVATE

    def gather_paged_resources(type, path)
      klass = "ArchivesSpace::#{type.to_s.capitalize}"
      result = @client.get(path, { page: 1 })
      results = []
      result["results"].each { |r| results << Module.const_get(klass).new(r) }
      last_page = result["last_page"]
      if last_page != 1
        (2..last_page).each do |i|
          result = @client.get(path, { page: i })
          result["results"].each { |r| results << Module.const_get(klass).new(r) }
        end
      end
      results
    end

    # convert a ruby hash to json and back (standardize keys as strings)
    def roundtrip(hash)
      tmp = JSON.generate(hash)
      JSON.parse(tmp)
    end

  end

end

__END__
