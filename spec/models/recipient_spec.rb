require 'spec_helper'

describe Recipient do
  before(:each) do
    @attrs = {:external_id => "123456", :recipient_type => 'student', :first_name => 'First', :last_name => 'Last'}
  end

  it "should create a recipient if all the right attributes are provided" do
    Recipient.create!(@attrs)
  end

  describe "validations" do
    it "should require an external_id" do
      bad_recipient = Recipient.new(@attrs.merge(:external_id => '    '))
      bad_recipient.should_not be_valid
    end

    it "should require a recipient_type" do
      bad_recipient = Recipient.new(@attrs.merge(:recipient_type => '    '))
      bad_recipient.should_not be_valid
    end

    it "should require a first_name" do
      bad_recipient = Recipient.new(@attrs.merge(:first_name => '    '))
      bad_recipient.should_not be_valid
    end

    it "should require a last_name" do
      bad_recipient = Recipient.new(@attrs.merge(:last_name => '    '))
      bad_recipient.should_not be_valid
    end

    it "should require a unique external_id/recipient_type combo" do
      Recipient.create!(@attrs)
      bad_recipient = Recipient.new(@attrs)
      bad_recipient.should_not be_valid
    end

    it "should allow the same external_id for different recipient_types" do
      Recipient.create!(@attrs)
      good_recipient = Recipient.new(@attrs.merge(:recipient_type => 'staff'))
      good_recipient.should be_valid
    end

  end

  describe "get message delivery methods" do
    before(:each) do
      @student_1 = Factory(:recipient)
      @student_1_phone = Factory(:contact_method, :delivery_route => '19071111111', :recipient => @student_1);
      Factory(:delivery_option, :scope_id => @student_1.id, :contact_method => @student_1_phone, :options => ['outreach'])
      @powerschool_demographics = Factory(:recipient, :first_name => 'PowerSchool', :last_name => 'Demographics', :recipient_type => 'default')
      @powerschool_phone_1 = Factory(:contact_method, :delivery_route => '19072221111', :recipient => @powerschool_demographics);
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_1.id, :contact_method => @powerschool_phone_1, :options => ['emergency'])
      @powerschool_phone_2 = Factory(:contact_method, :delivery_route => '19072222222', :recipient => @powerschool_demographics);
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_1.id, :contact_method => @powerschool_phone_2, :options => ['emergency'])
      @student_1.reverse_linked_recipients.create!(:parent_id => @powerschool_demographics.id)

      @student_2 = Factory(:recipient, :external_id => 's111222', :first_name => 'TestB', :last_name => 'Student', :recipient_type => 'student')
      @powerschool_demographics_2 = Factory(:recipient, :external_id => 's111222', :first_name => 'PowerSchool', :last_name => 'Demographics', :recipient_type => 'default')
      @powerschool_phone_3 = Factory(:contact_method, :delivery_route => '19073331111', :recipient => @powerschool_demographics_2);
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_2.id, :contact_method => @powerschool_phone_3, :options => ['emergency'])
      @student_2.reverse_linked_recipients.create!(:parent_id => @powerschool_demographics_2.id)

      @parent_1 = Factory(:recipient, :external_id => 'p1', :first_name => 'One', :last_name => 'Parent', :recipient_type => 'parent')
      @parent_1.add_student!(@student_1)
      @parent_1.add_student!(@student_2)
      @parent_1_phone_1 = Factory(:contact_method, :delivery_route => '19074441111', :recipient => @parent_1);
      @parent_1_phone_2 = Factory(:contact_method, :delivery_route => '19074442222', :recipient => @parent_1);
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_1.id, :contact_method => @parent_1_phone_1, :options => ['outreach','attendance'])
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_2.id, :contact_method => @parent_1_phone_1, :options => ['outreach'])
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_2.id, :contact_method => @parent_1_phone_2, :options => ['attendance'])

      @parent_2 = Factory(:recipient, :external_id => 'p2', :first_name => 'Two', :last_name => 'Parent', :recipient_type => 'parent')
      @parent_2.add_student!(@student_1)
      @parent_2_phone_1 = Factory(:contact_method, :delivery_route => '19075551111', :recipient => @parent_2);
      @parent_2_phone_2 = Factory(:contact_method, :delivery_route => '19075552222', :recipient => @parent_2);
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_1.id, :contact_method => @parent_2_phone_1, :options => ['outreach','attendance'])
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_1.id, :contact_method => @parent_2_phone_2, :options => ['outreach'])

    end

    it "should have a contacts method" do
      @student_1.should respond_to(:contacts)
    end

    describe "should return the correct phone numbers for a given message type" do

      it "emergency" do
        contacts = @student_1.contacts('emergency')
        ['19071111111','19072221111','19072222222','19074441111','19074442222','19075551111','19075552222'].each do |good_phone|
          contacts.include?(good_phone).should be_true
        end
        ['19073331111'].each do |bad_phone|
          contacts.include?(bad_phone).should_not be_true
        end

        contacts = @student_2.contacts('emergency')
        ['19073331111','19074441111','19074442222'].each do |good_phone|
          contacts.include?(good_phone).should be_true
        end
        ['19071111111','19072221111','19072222222','19075551111','19075552222'].each do |bad_phone|
          contacts.include?(bad_phone).should_not be_true
        end
      end

      it "outreach" do
        contacts = @student_1.contacts('outreach')
        ['19071111111','19074441111','19075552222','19075551111'].each do |good_phone|
          contacts.include?(good_phone).should be_true
        end
        ['19072221111','19072222222','19073331111','19074442222'].each do |bad_phone|
          contacts.include?(bad_phone).should_not be_true
        end

        contacts = @student_2.contacts('outreach')
        ['19074441111'].each do |good_phone|
          contacts.include?(good_phone).should be_true
        end
        ['19071111111','19072221111','19072222222','19073331111','19074442222','19075551111','19075552222'].each do |bad_phone|
          contacts.include?(bad_phone).should_not be_true
        end
      end

      it "attendance" do
        contacts = @student_1.contacts('attendance')
        ['19074441111','19075551111'].each do |good_phone|
          contacts.include?(good_phone).should be_true
        end
        ['19071111111','19072221111','19072222222','19073331111','19074442222','19075552222'].each do |bad_phone|
          contacts.include?(bad_phone).should_not be_true
        end

        contacts = @student_2.contacts('attendance')
        ['19074442222'].each do |good_phone|
          contacts.include?(good_phone).should be_true
        end
        ['19071111111','19072221111','19072222222','19073331111','19074441111','19075551111','19075552222'].each do |bad_phone|
          contacts.include?(bad_phone).should_not be_true
        end
      end

    end
  end

end
