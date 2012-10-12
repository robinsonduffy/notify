require 'spec_helper'

describe MessageType do
  before(:each) do
    @attrs = {:name => "emergency"}
  end

  it "should create a message type if all the right attributes are provided" do
    MessageType.create!(@attrs)
  end

  describe "validations" do
    it "should require a name" do
      bad_message_type = MessageType.new(@attrs.merge(:name => '    '))
      bad_message_type.should_not be_valid
    end

    it "should require a unique name" do
      MessageType.create!(@attrs)
      bad_message_type = MessageType.new(@attrs)
      bad_message_type.should_not be_valid
    end
  end
end
