require 'spec_helper'

describe RecipientsController do
  render_views

  describe "GET 'index'" do

    describe "for non-users" do
      it "should deny access" do
        get :index
        response.should redirect_to(login_path)
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['full sender']
        get :index
        response.should redirect_to(login_path)
      end
    end

    describe "for recipient viewers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['recipient viewer']
      end

      it "should allow access" do
        get :index
        response.should be_success
      end

      it "should not have a 'create new recipient' link" do
        get :index
        response.should_not have_selector("a", :content => "Create New Recipient", :href => new_recipient_path)
      end
    end

    describe "for recipient managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['recipient manager']
      end

      it "should allow access" do
        get :index
        response.should be_success
      end

      it "should have a 'create new recipient' link" do
        get :index
        response.should have_selector("a", :content => "Create New Recipient", :href => new_recipient_path)
      end
    end
  end

  describe "GET 'new'" do
    describe "for non-users" do
      it "should deny access" do
        get :new
        response.should redirect_to(login_path)
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['full sender']
        get :new
        response.should redirect_to(login_path)
      end
    end

    describe "for recipient viewers" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['recipient viewer']
        get :new
        response.should redirect_to(login_path)
      end
    end

    describe "for recipient managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['recipient manager']
      end

      it "should allow access" do
        get :new
        response.should be_success
      end
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @attrs = {:first_name => 'Test', :last_name => 'Recipient', :recipient_type_id => '1', :external_id => '12345'}
    end

    describe "for non-users" do
      it "should deny access" do
        post :create, :recipient => @attrs
        response.should_not be_success
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['full sender']
        post :create, :recipient => @attrs
        response.should_not be_success
      end
    end

    describe "for recipient viewers" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['recipient viewer']
        post :create, :recipient => @attrs
        response.should_not be_success
      end
    end

    describe "for recipient managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['recipient manager']
      end

      describe "failure" do
        it "should not create a new recipient" do
          lambda do
            post :create, :recipient => @attrs.merge(:first_name => '  ')
          end.should_not change(Recipient, :count)
        end

        it "should render the form again" do
          post :create, :recipient => @attrs.merge(:first_name => '  ')
          response.should render_template('new')
        end
      end

      describe "success" do
        it "should create a new recipient" do
          lambda do
            post :create, :recipient => @attrs
          end.should change(Recipient, :count).by(1)
        end

        it "should redirect to the recipient detail page" do
          post :create, :recipient => @attrs

          response.should redirect_to(recipient_path(assigns(:recipient)))
        end
      end
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @recipient = Factory(:recipient)
    end

    describe "for non-users" do
      it "should deny access" do
        get :show, :id => @recipient
        response.should redirect_to(login_path)
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['full sender']
        get :show, :id => @recipient
        response.should redirect_to(login_path)
      end
    end

    describe "for recipient viewers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['recipient viewer']
      end

      it "should allow access" do
        get :show, :id => @recipient
        response.should be_success
      end

      it "should not have an edit link" do
        get :show, :id => @recipient
        response.should_not have_selector("a", :href => edit_recipient_path(@recipient))
      end
    end

    describe "for recipient managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['recipient manager']
      end

      it "should allow access" do
        get :show, :id => @recipient
        response.should be_success
      end

      it "should have an edit link" do
        get :show, :id => @recipient
        response.should have_selector("a", :href => edit_recipient_path(@recipient))
      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @recipient = Factory(:recipient)
    end

    describe "for non-users" do
      it "should deny access" do
        get :edit, :id => @recipient
        response.should redirect_to(login_path)
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['full sender']
        get :edit, :id => @recipient
        response.should redirect_to(login_path)
      end
    end

    describe "for recipient viewers" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['recipient viewer']
        get :edit, :id => @recipient
        response.should redirect_to(login_path)
      end
    end

    describe "for recipient managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['recipient manager']
      end

      it "should allow access" do
        get :edit, :id => @recipient
        response.should be_success
      end
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @recipient = Factory(:recipient)
      @attrs = {:first_name => 'New Test', :last_name => 'Recipient', :recipient_type_id => '1', :external_id => '12345NEW'}
    end

    describe "for non-users" do
      it "should deny access" do
        put :update, :id => @recipient, :recipient => @attrs
        response.should_not be_success
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['full sender']
        put :update, :id => @recipient, :recipient => @attrs
        response.should_not be_success
      end
    end

    describe "for recipient viewers" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['recipient viewer']
        put :update, :id => @recipient, :recipient => @attrs
        response.should_not be_success
      end
    end

    describe "for recipient managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['recipient manager']
      end

      describe "failure" do
        it "should render the form again" do
          put :update, :id => @recipient, :recipient => @attrs.merge(:first_name => '   ')
          response.should render_template('edit')
        end
      end

      describe "success" do
        it "should redirect to the recipient detail page" do
          put :update, :id => @recipient, :recipient => @attrs
          response.should redirect_to recipient_path(@recipient)
        end

        it "should update the recipient info" do
          put :update, :id => @recipient, :recipient => @attrs
          @recipient.reload
          (@recipient.first_name == @attrs[:first_name]).should be_true
          (@recipient.external_id == @attrs[:external_id]).should be_true
        end
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @recipient = Factory(:recipient)
    end

    describe "for non-users" do
      it "should deny access" do
        delete :destroy, :id => @recipient
        response.should_not be_success
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['full sender']
        delete :destroy, :id => @recipient
        response.should_not be_success
      end
    end

    describe "for recipient viewers" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['recipient viewer']
        delete :destroy, :id => @recipient
        response.should_not be_success
      end
    end

    describe "for recipient managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['recipient manager']
      end

      it "should destroy the recipient" do
        lambda do
          delete :destroy, :id => @recipient
        end.should change(Recipient, :count).by(-1)
      end

      it "should redirect to the list index page" do
        delete :destroy, :id => @recipient
        response.should redirect_to recipients_path
      end
    end
  end
end
