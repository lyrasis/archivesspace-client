require 'spec_helper'

def create_repository!
  repository = @client.template_for "repository"
  repository["repo_code"] = "ABC"
  repository["name"] = "ABC Archives"
  @client.create "repository", repository 
end

def create_user!
  user = @client.template_for "user"
  user["username"] = "lmessi"
  user["name"] = "Lionel Messi"
  @client.create "user", user, { password: "123456" }  
end

def delete!(object)
  @client.delete object
end

describe "interacting with the api" do

  before :all do
    @client = ArchivesSpace::Client.new
    @client.login "admin", "admin"
  end

  it "requesting version should retrieve version information" do
    expect(@client.version["databaseProductName"]).to eq "Apache Derby"
  end

  it "should allow a repository to be created from a template, updated and deleted" do
    repository = create_repository!
    expect(repository["repo_code"]).to eq "ABC"

    repository["name"] = "DEF Archives"
    repository = @client.update repository
    expect(repository["name"]).to eq "DEF Archives"

    result = delete! repository
    expect(result["status"]).to eq "Deleted"
  end

  it "should allow a user to be created from a template, updated and deleted" do
    user = create_user!
    expect(user["username"]).to eq "lmessi"
    
    user["name"] = "Cristiano Ronaldo"
    user = @client.update user
    expect(user["name"]).to eq "Cristiano Ronaldo"

    result = delete! user
    expect(result["status"]).to eq "Deleted"
  end

  it "should retrieve permissions", pending: true do
    @client.permissions
  end

end
