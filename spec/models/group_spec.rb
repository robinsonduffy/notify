require 'spec_helper'

describe Group do
  before(:each) do
    @user = Factory(:user)
    @attrs = {:name => "Test Group", :user_id => @user.id}
  end

  it "should create a recipient if all the right attributes are provided" do
    Group.create!(@attrs)
  end

  describe "validations" do
    it "should require a name" do
      bad_group = Group.new(@attrs.merge(:name => '    '))
      bad_group.should_not be_valid
    end

    it "should require a user_id" do
      bad_group = Group.new(@attrs.merge(:user_id => '    '))
      bad_group.should_not be_valid
    end

    it "should require a unique name" do
      Group.create!(@attrs)
      bad_group = Group.new(@attrs)
      bad_group.should_not be_valid
    end
  end

  describe "relationships" do
    before(:each) do
      @group = Group.create!(@attrs)
    end

    it "should have a user" do
      @group.should respond_to(:user)
    end

    it "should return the correct user" do
      (@group.user == @user).should be_true
    end

    it "should have many recipients" do
      @group.should respond_to(:recipients)
    end

  end
end
