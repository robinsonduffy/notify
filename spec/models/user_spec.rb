# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  username   :string(255)
#  password   :string(255)
#  name       :string(255)
#  admin      :boolean
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
  before(:each) do
    @attrs = {:username => "UserName", :password => "foobar"}
  end

  it "should create a user if all the right attributes are provided" do
    User.create!(@attrs)
  end

  it "should require a username" do
    no_name_user = User.new(@attrs.merge(:username => ""))
    no_name_user.should_not be_valid
  end

  it "should require a password (for now)" do
    no_password_user = User.new(@attrs.merge(:password => ""))
    no_password_user.should_not be_valid
  end

  it "should require unique usernames" do
    User.create!(@attrs)
    same_username_user = User.new(@attrs)
    same_username_user.should_not be_valid
  end

  describe "authenticate method" do

    before(:each) do
      @user = User.create!(@attrs)
    end

    it "should exist" do
      User.should respond_to(:authenticate)
    end

    it "should return nil on username/password mismatch" do
      User.authenticate(@attrs[:username], "wrong_password").should be_nil
    end

    it "should return nil on bad username" do
      User.authenticate("NotAUser", @attrs[:password]).should be_nil
    end

    it "should return the user on good username, good password" do
      User.authenticate(@attrs[:username], @attrs[:password]).should == @user
    end

  end

end
