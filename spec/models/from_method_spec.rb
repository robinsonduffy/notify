require 'spec_helper'

describe FromMethod do
  before(:each) do
    @attrs = {:from_method_type => "email", :from_method => "test@example.com", :name => "Test Email"}
  end

  it "should create a from_method if all the right attributes are provided" do
    FromMethod.create!(@attrs)
  end

  describe "validations" do
    it "should require a from_method_type" do
      bad_from = FromMethod.new(@attrs.merge(:from_method_type => '    '))
      bad_from.should_not be_valid
    end

    it "should require a from_method" do
      bad_from = FromMethod.new(@attrs.merge(:from_method => '    '))
      bad_from.should_not be_valid
    end

    it "should require a unique from_method/from_method_type combo" do
      FromMethod.create!(@attrs)
      bad_from = FromMethod.new(@attrs)
      bad_from.should_not be_valid
    end

    it "should accept valid email address" do
      ["user@foo.com", "THE_USER@foo.bar.org", "first.last@foo.jp", "email_with_space_at_end@example.com "].each do |good_address|
        good_from = FromMethod.new(@attrs.merge(:from_method_type => 'email', :from_method => good_address))
        good_from.should be_valid
      end
    end

    it "should reject invalid email addresses" do
      ["user@foo,com", "user_at_foo.org", "not even close to a real address@example.com", "example.user@foo."].each do |bad_address|
        bad_from = FromMethod.new(@attrs.merge(:from_method_type => 'email', :from_method => bad_address))
        bad_from.should_not be_valid
      end
    end

    it "should accept valid phone numbers" do
      ["(907) 123-1234", "(907)123-1234", "907-123-1234", "907 123-1234"].each do |good_phone|
        good_from = FromMethod.new(@attrs.merge(:from_method_type => 'phone', :from_method => good_phone))
        good_from.should be_valid
      end
    end

    it "should reject invalid phone numbers" do
      ["123-1234", "Not a phone number at all", "1231234", "123-123456", "(90)123-1234"].each do |bad_phone|
        bad_from = FromMethod.new(@attrs.merge(:from_method_type => 'phone', :from_method => bad_phone))
        bad_from.should_not be_valid
      end
    end
  end
end
