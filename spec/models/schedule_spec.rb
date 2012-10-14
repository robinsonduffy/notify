require 'spec_helper'

describe Schedule do
  before(:each) do
    @attrs = {:delivery_time => Time.now+1.day, :message => Factory(:message, :user => Factory(:user))}
  end

  it "should create a schedule if all the right attributes are provided" do
    Schedule.create!(@attrs)
  end

  describe "validations" do
    it "should require a delivery_time" do
      bad_schedule = Schedule.new(@attrs.merge(:delivery_time => nil))
      bad_schedule.should_not be_valid
    end

    it "should require a message" do
      bad_schedule = Schedule.new(@attrs.merge(:message => nil))
      bad_schedule.should_not be_valid
    end

    it "should require a delivery_time in the future" do
      bad_schedule = Schedule.new(@attrs.merge(:delivery_time => Time.now-1.day))
      bad_schedule.should_not be_valid
    end

  end
end
