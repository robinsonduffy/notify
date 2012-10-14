require 'spec_helper'

describe Message do
  before(:each) do
    @attrs = {:name => "Test Message", :status => 1, :user_id => Factory(:user).id}
  end

  it "should create a message if all the right attributes are provided" do
    Message.create!(@attrs)
  end

  describe "validations" do
    it "should require a name" do
      bad_message = Message.new(@attrs.merge(:name => '    '))
      bad_message.should_not be_valid
    end

    it "should require a status" do
      bad_message = Message.new(@attrs.merge(:status => nil))
      bad_message.should_not be_valid
    end
    
    it "should require a valid status" do
      bad_message = Message.new(@attrs.merge(:status => 5))
      bad_message.should_not be_valid
    end

    it "should require a user" do
      bad_message = Message.new(@attrs.merge(:user => nil))
      bad_message.should_not be_valid
    end
  end
end
