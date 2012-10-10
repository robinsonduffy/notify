require 'spec_helper'

describe RecipientType do
  before(:each) do
    @attrs = {:name => "Test Recipient Type"}
  end

  it "should create a school if all the right attributes are provided" do
    RecipientType.create!(@attrs)
  end

  describe "validations" do
    it "should require a name" do
      bad_recipient_type = RecipientType.new(@attrs.merge(:name => '    '))
      bad_recipient_type.should_not be_valid
    end

    it "should require a unique name" do
      RecipientType.create!(@attrs)
      bad_recipient_type = RecipientType.new(@attrs)
      bad_recipient_type.should_not be_valid
    end
  end

  describe "relationships" do
    before(:each) do
      @recipient_type1 = RecipientType.create!(@attrs)
      @recipient_type2 = RecipientType.create!(@attrs.merge(:name => 'Another Type'))
      @recipient_1 = Factory(:recipient, :recipient_type_id => @recipient_type1.id)
      @recipient_2 = Factory(:recipient, :recipient_type_id => @recipient_type2.id, :external_id => '987654')
      @recipient_3 = Factory(:recipient, :recipient_type_id => @recipient_type1.id, :external_id => '765432')
    end

    it "should have a recipients method" do
      @recipient_type1.should respond_to(:recipients)
    end

    it "should return the correct recipients" do
      [@recipient_1, @recipient_3].each do |recipient|
        @recipient_type1.recipients.include?(recipient).should be_true
        @recipient_type2.recipients.include?(recipient).should_not be_true
      end
      [@recipient_2].each do |recipient|
        @recipient_type2.recipients.include?(recipient).should be_true
        @recipient_type1.recipients.include?(recipient).should_not be_true
      end
    end
  end
end
