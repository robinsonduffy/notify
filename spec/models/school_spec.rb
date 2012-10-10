require 'spec_helper'

describe School do
  before(:each) do
    @attrs = {:name => "Test School"}
  end

  it "should create a school if all the right attributes are provided" do
    School.create!(@attrs)
  end

  describe "validations" do
    it "should require a name" do
      bad_school = School.new(@attrs.merge(:name => '    '))
      bad_school.should_not be_valid
    end

    it "should require a unique name" do
      School.create!(@attrs)
      bad_school = School.new(@attrs)
      bad_school.should_not be_valid
    end
  end

  describe "relationships" do
    before(:each) do
      @school = School.create!(@attrs)
      recipient_type = Factory(:recipient_type)
      @recipient_1 = Factory(:recipient, :recipient_type_id => recipient_type.id)
      @recipient_2 = Factory(:recipient, :recipient_type_id => recipient_type.id, :external_id => '987654')
      @recipient_3 = Factory(:recipient, :recipient_type_id => recipient_type.id, :external_id => '765432')
    end

    it "should have a recipients method" do
      @school.should respond_to(:recipients)
    end

    it "should return the correct recipients" do
      @school.recipients<<(@recipient_1)
      @school.recipients<<(@recipient_3)
      [@recipient_1, @recipient_3].each do |recipient|
        @school.recipients.include?(recipient).should be_true
      end
      [@recipient_2].each do |recipient|
        @school.recipients.include?(recipient).should_not be_true
      end
    end
  end


end
