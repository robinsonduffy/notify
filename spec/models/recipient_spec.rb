require 'spec_helper'

describe Recipient do
  before(:each) do
    @message_type_emergency = Factory(:message_type, :name => 'emergency')
    @message_type_outreach = Factory(:message_type, :name => 'outreach')
    @message_type_attendance = Factory(:message_type, :name => 'attendance')
    @recipient_type_student = Factory(:recipient_type, :name => 'Student')
    @recipient_type_parent = Factory(:recipient_type, :name => 'Parent')
    @recipient_type_staff = Factory(:recipient_type, :name => 'Staff')
    @contact_method_type_phone = Factory(:contact_method_type, :name => 'phone')
    @contact_method_type_sms = Factory(:contact_method_type, :name => 'sms')
    @contact_method_type_email = Factory(:contact_method_type, :name => 'email')
    @recipient_type_default = Factory(:recipient_type, :name => 'Default')
    @attrs = {:external_id => "123456", :recipient_type_id => @recipient_type_student.id, :first_name => 'First', :last_name => 'Last'}
  end

  it "should create a recipient if all the right attributes are provided" do
    Recipient.create!(@attrs)
  end

  describe "validations" do
    it "should require an external_id" do
      bad_recipient = Recipient.new(@attrs.merge(:external_id => '    '))
      bad_recipient.should_not be_valid
    end

    it "should require a recipient_type_id" do
      bad_recipient = Recipient.new(@attrs.merge(:recipient_type_id => '    '))
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
      good_recipient = Recipient.new(@attrs.merge(:recipient_type_id => @recipient_type_staff.id))
      good_recipient.should be_valid
    end

  end

  describe "get message delivery methods" do
    before(:each) do
      @student_1 = Factory(:recipient, :recipient_type_id => @recipient_type_student.id)
      @student_1_phone = Factory(:contact_method, :delivery_route => '19071111111', :recipient => @student_1, :contact_method_type => @contact_method_type_phone)
      Factory(:delivery_option, :scope_id => @student_1.id, :contact_method => @student_1_phone, :options => ['outreach'])
      @powerschool_demographics = Factory(:recipient, :first_name => 'PowerSchool', :last_name => 'Demographics', :recipient_type_id => @recipient_type_default.id)
      @powerschool_phone_1 = Factory(:contact_method, :delivery_route => '19072221111', :recipient => @powerschool_demographics, :contact_method_type => @contact_method_type_phone);
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_1.id, :contact_method => @powerschool_phone_1, :options => ['emergency'])
      @powerschool_phone_2 = Factory(:contact_method, :delivery_route => '19072222222', :recipient => @powerschool_demographics, :contact_method_type => @contact_method_type_phone);
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_1.id, :contact_method => @powerschool_phone_2, :options => ['emergency'])
      @student_1.reverse_linked_recipients.create!(:parent_id => @powerschool_demographics.id)

      @student_2 = Factory(:recipient, :external_id => 's111222', :first_name => 'TestB', :last_name => 'Student', :recipient_type_id => @recipient_type_student.id)
      @powerschool_demographics_2 = Factory(:recipient, :external_id => 's111222', :first_name => 'PowerSchool', :last_name => 'Demographics', :recipient_type_id => @recipient_type_default.id)
      @powerschool_phone_3 = Factory(:contact_method, :delivery_route => '19073331111', :recipient => @powerschool_demographics_2, :contact_method_type => @contact_method_type_phone);
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_2.id, :contact_method => @powerschool_phone_3, :options => ['emergency'])
      @student_2.reverse_linked_recipients.create!(:parent_id => @powerschool_demographics_2.id)

      @parent_1 = Factory(:recipient, :external_id => 'p1', :first_name => 'One', :last_name => 'Parent', :recipient_type_id => @recipient_type_parent.id)
      @parent_1.add_student!(@student_1)
      @parent_1.add_student!(@student_2)
      @parent_1_phone_1 = Factory(:contact_method, :delivery_route => '19074441111', :recipient => @parent_1, :contact_method_type => @contact_method_type_phone);
      @parent_1_phone_2 = Factory(:contact_method, :delivery_route => '19074442222', :recipient => @parent_1, :contact_method_type => @contact_method_type_phone);
      @parent_1_email_1 = Factory(:contact_method, :contact_method_type => 'email', :delivery_route => 'parent1@example.com', :recipient => @parent_1, :contact_method_type => @contact_method_type_email)
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_1.id, :contact_method => @parent_1_phone_1, :options => ['outreach','attendance'])
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_2.id, :contact_method => @parent_1_phone_1, :options => ['outreach'])
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_1.id, :contact_method => @parent_1_email_1, :options => ['outreach','attendance'])
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_2.id, :contact_method => @parent_1_phone_2, :options => ['attendance'])

      @parent_2 = Factory(:recipient, :external_id => 'p2', :first_name => 'Two', :last_name => 'Parent', :recipient_type_id => @recipient_type_parent.id)
      @parent_2.add_student!(@student_1)
      @parent_2_phone_1 = Factory(:contact_method, :delivery_route => '19075551111', :recipient => @parent_2, :contact_method_type => @contact_method_type_phone);
      @parent_2_phone_2 = Factory(:contact_method, :delivery_route => '19075552222', :recipient => @parent_2, :contact_method_type => @contact_method_type_phone);
      @parent_2_email_1 = Factory(:contact_method, :contact_method_type => 'email', :delivery_route => 'parent2@example.com', :recipient => @parent_2, :contact_method_type => @contact_method_type_email)
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_1.id, :contact_method => @parent_2_phone_1, :options => ['outreach','attendance'])
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_1.id, :contact_method => @parent_2_phone_2, :options => ['outreach'])
      Factory(:delivery_option, :option_scope => 'link', :scope_id => @student_1.id, :contact_method => @parent_2_email_1, :options => ['outreach'])

    end

    it "should have a contacts method" do
      @student_1.should respond_to(:contacts)
    end

    describe "should return the correct phone numbers for a given message type" do

      describe "emergency" do
        it "phone" do
          contacts = @student_1.contacts(@message_type_emergency,['phone'])
          [@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@parent_1_phone_1,@parent_1_phone_2,@parent_2_phone_1,@parent_2_phone_2].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@powerschool_phone_3,@parent_1_email_1,@parent_2_email_1].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end

          contacts = @student_2.contacts(@message_type_emergency,['phone'])
          [@powerschool_phone_3,@parent_1_phone_1,@parent_1_phone_2].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@parent_2_phone_1,@parent_2_phone_2,@parent_1_email_1,@parent_2_email_1].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end
        end

        it "phone & email" do
          contacts = @student_1.contacts(@message_type_emergency,['phone','email'])
          [@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@parent_1_phone_1,@parent_1_phone_2,@parent_2_phone_1,@parent_2_phone_2,@parent_1_email_1,@parent_2_email_1].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@powerschool_phone_3].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end

          contacts = @student_2.contacts(@message_type_emergency,['phone','email'])
          [@powerschool_phone_3,@parent_1_phone_1,@parent_1_phone_2,@parent_1_email_1].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@parent_2_phone_1,@parent_2_phone_2,@parent_2_email_1].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end
        end

        it "email" do
          contacts = @student_1.contacts(@message_type_emergency,['email'])
          [@parent_1_email_1,@parent_2_email_1].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@powerschool_phone_3,@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@parent_1_phone_1,@parent_1_phone_2,@parent_2_phone_1,@parent_2_phone_2].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end

          contacts = @student_2.contacts(@message_type_emergency,['email'])
          [@parent_1_email_1].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@powerschool_phone_3,@parent_1_phone_1,@parent_1_phone_2,@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@parent_2_phone_1,@parent_2_phone_2,@parent_2_email_1].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end
        end
      end

      describe "outreach" do
        it "phone" do
          contacts = @student_1.contacts(@message_type_outreach,['phone'])
          [@student_1_phone,@parent_1_phone_1,@parent_2_phone_2,@parent_2_phone_1].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@powerschool_phone_1,@powerschool_phone_2,@powerschool_phone_3,@parent_1_phone_2,@parent_1_email_1,@parent_2_email_1].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end

          contacts = @student_2.contacts(@message_type_outreach,['phone'])
          [@parent_1_phone_1].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@powerschool_phone_3,@parent_1_phone_2,@parent_2_phone_1,@parent_2_phone_2,@parent_1_email_1,@parent_2_email_1].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end
        end

        it "phone & email" do
          contacts = @student_1.contacts(@message_type_outreach,['phone','email'])
          [@student_1_phone,@parent_1_phone_1,@parent_2_phone_2,@parent_2_phone_1,@parent_1_email_1,@parent_2_email_1].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@powerschool_phone_1,@powerschool_phone_2,@powerschool_phone_3,@parent_1_phone_2].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end

          contacts = @student_2.contacts(@message_type_outreach,['phone','email'])
          [@parent_1_phone_1].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@powerschool_phone_3,@parent_1_phone_2,@parent_2_phone_1,@parent_2_phone_2,@parent_1_email_1,@parent_2_email_1].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end
        end

        it "email" do
          contacts = @student_1.contacts(@message_type_outreach,['email'])
          [@parent_1_email_1,@parent_2_email_1].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@student_1_phone,@parent_1_phone_1,@parent_2_phone_2,@parent_2_phone_1,@powerschool_phone_1,@powerschool_phone_2,@powerschool_phone_3,@parent_1_phone_2].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end

          contacts = @student_2.contacts(@message_type_outreach,['email'])
          [].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@parent_1_phone_1,@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@powerschool_phone_3,@parent_1_phone_2,@parent_2_phone_1,@parent_2_phone_2,@parent_1_email_1,@parent_2_email_1].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end
        end
      end

      describe "attendance" do
        it "phone" do
          contacts = @student_1.contacts(@message_type_attendance,['phone'])
          [@parent_1_phone_1,@parent_2_phone_1].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@powerschool_phone_3,@parent_1_phone_2,@parent_2_phone_2,@parent_1_email_1,@parent_2_email_1].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end

          contacts = @student_2.contacts(@message_type_attendance,['phone'])
          [@parent_1_phone_2].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@powerschool_phone_3,@parent_1_phone_1,@parent_2_phone_1,@parent_2_phone_2,@parent_1_email_1,@parent_2_email_1].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end
        end

        it "phone & email" do
          contacts = @student_1.contacts(@message_type_attendance,['phone','email'])
          [@parent_1_phone_1,@parent_2_phone_1,@parent_1_email_1].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@powerschool_phone_3,@parent_1_phone_2,@parent_2_phone_2,@parent_2_email_1].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end

          contacts = @student_2.contacts(@message_type_attendance,['phone','email'])
          [@parent_1_phone_2].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@powerschool_phone_3,@parent_1_phone_1,@parent_2_phone_1,@parent_2_phone_2,@parent_1_email_1,@parent_2_email_1].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end
        end

        it "email" do
          contacts = @student_1.contacts(@message_type_attendance,['email'])
          [@parent_1_email_1].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@parent_1_phone_1,@parent_2_phone_1,@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@powerschool_phone_3,@parent_1_phone_2,@parent_2_phone_2,@parent_2_email_1].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end

          contacts = @student_2.contacts(@message_type_attendance,['email'])
          [].each do |good_phone|
            contacts.include?(good_phone).should be_true
          end
          [@parent_1_phone_2,@student_1_phone,@powerschool_phone_1,@powerschool_phone_2,@powerschool_phone_3,@parent_1_phone_1,@parent_2_phone_1,@parent_2_phone_2,@parent_1_email_1,@parent_2_email_1].each do |bad_phone|
            contacts.include?(bad_phone).should_not be_true
          end
        end
      end

    end
  end

  describe "relationships" do
    before(:each) do
      @recipient = Recipient.create!(@attrs)
    end

    describe "schools" do

      it "should have a schools method" do
        @recipient.should respond_to(:schools)
      end

      it "should return the correct schools" do
        school1 = Factory(:school)
        school2 = Factory(:school, :name => "Test School 2")
        school3 = Factory(:school, :name => "Test School 3")
        @recipient.schools<<(school1)
        @recipient.schools<<(school3)
        [school1, school3].each do |school|
          @recipient.schools.include?(school).should be_true
        end
        [school2].each do |school|
          @recipient.schools.include?(school).should_not be_true
        end
      end
    end

    describe "groups" do
      before(:each) do
        @user = Factory(:user)
      end
      it "should have a groups method" do
        @recipient.should respond_to(:groups)
      end

      it "should return the correct groups" do
        group1 = Factory(:group, :user_id => @user.id)
        group2 = Factory(:group, :user_id => @user.id, :name => "Test Group 2")
        group3 = Factory(:group, :user_id => @user.id, :name => "Test Group 3")
        @recipient.groups<<(group1)
        @recipient.groups<<(group3)
        [group1, group3].each do |group|
          @recipient.groups.include?(group).should be_true
        end
        [group2].each do |group|
          @recipient.groups.include?(group).should_not be_true
        end
      end
    end
  end

end
