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

def create_digital_object!(repository, title)
  digital_object = @client.template_for "digital_object"
  digital_object["digital_object_id"] = SecureRandom.hex
  digital_object["title"] = title
  @client.working_repository repository
  @client.create_with_context "digital_object", digital_object
end

def delete!(object)
  @client.delete object
end

describe "interacting with the api" do

  before :all do
    @client = ArchivesSpace::Client.new
    @client.login "admin", "admin"
  end

  context "System" do

    it "requesting version should retrieve version information" do
      expect(@client.version["databaseProductName"]).to eq "Apache Derby"
    end

  end

  context "Repositories" do

    it "should allow a repository to be created from a template, updated and deleted" do
      repository = create_repository!
      expect(repository["repo_code"]).to eq "ABC"

      repository["name"] = "DEF Archives"
      repository = @client.update repository
      expect(repository["name"]).to eq "DEF Archives"

      result = delete! repository
      expect(result["status"]).to eq "Deleted"
    end

  end

  context "Users" do

    it "should allow a user to be created from a template, updated and deleted" do
      user = create_user!
      expect(user["username"]).to eq "lmessi"

      user["name"] = "Cristiano Ronaldo"
      user = @client.update user
      expect(user["name"]).to eq "Cristiano Ronaldo"

      result = delete! user
      expect(result["status"]).to eq "Deleted"
    end

  end

  context "Working with Repository objects" do

    before :all do
      @repository = create_repository!
    end

    after :all do
      delete! @repository if @repository
    end

    context "Digital Objects" do

      it "should allow a digital object to be created from a template, updated and deleted" do
        digital_object = create_digital_object!(@repository, "The Moon")
        expect(digital_object["title"]).to eq "The Moon"

        digital_object["title"] = "The Earth"
        digital_object = @client.update digital_object
        expect(digital_object["title"]).to eq "The Earth"

        result = delete! digital_object
        expect(result["status"]).to eq "Deleted"
      end

      it "should retrieve digital objects" do
        digital_object1 = create_digital_object!(@repository, "The Moon")
        digital_object2 = create_digital_object!(@repository, "The Earth")
        digital_objects = @client.digital_objects
        expect(digital_objects.size).to eq 2
        delete! digital_object1
        delete! digital_object2
      end

      it "should retrieve digital objects by format" do
        digital_object1 = create_digital_object!(@repository, "The Moon")
        digital_object2 = create_digital_object!(@repository, "The Earth")
        digital_objects = @client.digital_objects( "mods" )
        expect(digital_objects.size).to eq 2
        digital_objects.each { |o| expect(o).to be_instance_of Nokogiri::XML::Document }
        delete! digital_object1
        delete! digital_object2
      end

      it "should convert digital object records to format" do
        digital_object1 = create_digital_object!(@repository, "The Moon")
        expect( @client.digital_object_to_xml(digital_object1) ).to be_instance_of Nokogiri::XML::Document
        delete! digital_object1
      end

      it "should yield content" do
        digital_object1 = create_digital_object!(@repository, "The Moon")
        digital_object2 = create_digital_object!(@repository, "The Earth")
        @client.digital_objects do |o|
          expect(o).to be_instance_of Hash
        end
        delete! digital_object1
        delete! digital_object2
      end

    end

    context "Resources" do

      #

    end

  end

  context "Permissions" do

    it "should retrieve permissions", pending: true do
      @client.permissions
    end

  end

end
