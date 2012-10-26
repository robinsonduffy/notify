require 'spec_helper'

describe FromMethodsController do
  render_views
  include ActionView::Helpers::NumberHelper

  describe "GET 'index'" do
    before(:each) do
      @from_method1 = Factory(:from_method, :from_method => "from@example.com", :from_method_type => 'email')
      @from_method2 = Factory(:from_method, :from_method => "907-123-1234", :from_method_type => 'phone')
    end

    describe "for non-users" do
      it "should deny access" do
        get :index
        response.should redirect_to(login_path)
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        get :index
        response.should redirect_to(login_path)
      end
    end

    describe "for system managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system manager']
      end

      it "should allow access" do
        get :index
        response.should be_success
      end

      it "should list the from methods" do
        get :index
        response.should have_selector("a", :content => @from_method1.from_method, :href => from_method_path(@from_method1))
        response.should have_selector("a", :content => @from_method2.from_method.humanize_phone_number, :href => from_method_path(@from_method2))
      end

      it "should have a 'create new from method' link" do
        get :index
        response.should have_selector("a", :content => "Create New From Method", :href => new_from_method_path)
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
        user.roles = ['location manager']
        get :new
        response.should redirect_to(login_path)
      end
    end

    describe "for system managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system manager']
      end

      it "should allow access" do
        get :new
        response.should be_success
      end
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @attrs = {:from_method_type => 'email', :from_method => 'text@example.com'}
    end

    describe "for non-users" do
      it "should deny access" do
        post :create, :school => @attrs
        response.should_not be_success
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        post :create, :school => @attrs
        response.should_not be_success
      end
    end

    describe "for system managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system manager']
      end

      describe "failure" do
        it "should not create a new school" do
          lambda do
            post :create, :from_method => @attrs.merge(:from_method => '  ')
          end.should_not change(FromMethod, :count)
        end

        it "should render the form again" do
          post :create, :from_method => @attrs.merge(:from_method => '  ')
          response.should render_template('new')
        end
      end

      describe "success" do
        it "should create a new school" do
          lambda do
            post :create, :from_method => @attrs
          end.should change(FromMethod, :count).by(1)
        end

        it "should redirect to the school detail page" do
          post :create, :from_method => @attrs
          response.should redirect_to(from_method_path(assigns(:from_method)))
        end
      end
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @from_method1 = Factory(:from_method)
    end

    describe "for non-users" do
      it "should deny access" do
        get :show, :id => @from_method1
        response.should redirect_to(login_path)
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        get :show, :id => @from_method1
        response.should redirect_to(login_path)
      end
    end

    describe "for system managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system manager']
      end

      it "should allow access" do
        get :show, :id => @from_method1
        response.should be_success
      end
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @from_method = Factory(:from_method)
      @attrs = {:from_method => 'new_address@example.com'}
    end

    describe "for non-users" do
      it "should deny access" do
        put :update, :id => @from_method, :from_method => @attrs
        response.should_not be_success
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        put :update, :id => @from_method, :from_method => @attrs
        response.should_not be_success
      end
    end

    describe "for system managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system manager']
      end

      describe "failure" do
        it "should render the form again" do
          put :update, :id => @from_method, :from_method => @attrs.merge(:from_method => '  ')
          response.should render_template('show')
        end
      end

      describe "success" do
        it "should redirect to the from method detail page" do
          put :update, :id => @from_method, :from_method => @attrs
          response.should redirect_to from_method_path(@from_method)
        end

        it "should update the from method info" do
          put :update, :id => @from_method, :from_method => @attrs
          @from_method.reload
          (@from_method.from_method == @attrs[:from_method]).should be_true
        end
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @from_method = Factory(:from_method)
    end

    describe "for non-users" do
      it "should deny access" do
        delete :destroy, :id => @from_method
        response.should_not be_success
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        delete :destroy, :id => @from_method
        response.should_not be_success
      end
    end

    describe "for system managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system manager']
      end

      it "should destroy the school" do
        lambda do
          delete :destroy, :id => @from_method
        end.should change(FromMethod, :count).by(-1)
      end

      it "should redirect to the school index page" do
        delete :destroy, :id => @from_method
        response.should redirect_to from_methods_path
      end
    end
  end
end
