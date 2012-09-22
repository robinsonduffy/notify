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

    describe "user" do
      it "should have a user" do
        @group.should respond_to(:user)
      end

      it "should return the correct user" do
        (@group.user == @user).should be_true
      end
    end

    describe "recipients" do

      it "should have many recipients" do
        @group.should respond_to(:recipients)
      end

      it "should return the correct recipients" do
        recipient1 = Factory(:recipient)
        recipient2 = Factory(:recipient, :external_id => '987654')
        recipient3 = Factory(:recipient, :external_id => '765432')
        @group.recipients<<(recipient1)
        @group.recipients<<(recipient3)
        [recipient1, recipient3].each do |recipient|
          @group.recipients.include?(recipient).should be_true
        end
        [recipient2].each do |recipient|
          @group.recipients.include?(recipient).should_not be_true
        end
      end

    end

  end
end
