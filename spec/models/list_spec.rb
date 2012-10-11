require 'spec_helper'

describe List do
  before(:each) do
    @user = Factory(:user)
    @attrs = {:name => "Test List", :description => 'This is a test list.', :user_id => @user.id}
  end

  it "should create a recipient if all the right attributes are provided" do
    List.create!(@attrs)
  end

  describe "validations" do
    it "should require a name" do
      bad_list = List.new(@attrs.merge(:name => '    '))
      bad_list.should_not be_valid
    end

    it "should require a user_id" do
      bad_list = List.new(@attrs.merge(:user_id => '    '))
      bad_list.should_not be_valid
    end

    it "should require a description" do
      bad_list = List.new(@attrs.merge(:description => '    '))
      bad_list.should_not be_valid
    end

    it "should require a unique name" do
      List.create!(@attrs)
      bad_list = List.new(@attrs.merge(:description => 'This is a different list with the same name but a different description'))
      bad_list.should_not be_valid
    end

  end

  describe "relationships" do
    before(:each) do
      @list = List.create!(@attrs)
    end

    describe "user" do
      it "should have a user" do
        @list.should respond_to(:user)
      end

      it "should return the correct user" do
        (@list.user == @user).should be_true
      end
    end

    describe "contact_methods" do

      it "should have many contact_methods" do
        @list.should respond_to(:contact_methods)
      end

      it "should return the correct contact_methods" do
        @contact_method_type_phone = Factory(:contact_method_type, :name => 'phone')
        @contact_method_type_sms = Factory(:contact_method_type, :name => 'sms')
        @contact_method_type_email = Factory(:contact_method_type, :name => 'email')
        recipient_type = Factory(:recipient_type)
        recipient1 = Factory(:recipient, :recipient_type_id => recipient_type.id)
        contact_method1 = Factory(:contact_method, :recipient_id => recipient1.id, :contact_method_type => @contact_method_type_phone)
        contact_method2 = Factory(:contact_method, :delivery_route => '19071112222', :recipient_id => recipient1.id, :contact_method_type => @contact_method_type_phone)
        recipient2 = Factory(:recipient, :recipient_type_id => recipient_type.id, :external_id => '987654')
        contact_method3 = Factory(:contact_method, :delivery_route => '19071113333', :recipient_id => recipient2.id, :contact_method_type => @contact_method_type_phone)
        @list.contact_methods<<(contact_method1)
        @list.contact_methods<<(contact_method3)
        [contact_method1, contact_method3].each do |contact_method|
          @list.contact_methods.include?(contact_method).should be_true
        end
        [contact_method2].each do |contact_method|
          @list.contact_methods.include?(contact_method).should_not be_true
        end
      end

    end

  end
end
