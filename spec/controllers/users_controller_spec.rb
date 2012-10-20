require 'spec_helper'

describe UsersController do
  render_views
  describe "GET 'show'" do

    before(:each) do
      @show_user = Factory(:user, :username => "show_user")
    end

    describe "for logged out users" do
      it "should deny access" do
        get :show, :id => @show_user
        response.should redirect_to(login_path)
      end
    end

    describe "for non-admin users" do
      before(:each) do
        @user = test_login(Factory(:user))
      end

      it "should deny access" do
        get :show, :id => @show_user
        response.should redirect_to(login_path)
      end
    end

    describe "for admin users" do
      before(:each) do
        @admin_user = test_login(Factory(:user, :username => 'admin'))
        @admin_user.roles = ["system admin"]
        @admin_user.save
      end

      it "should be successful" do
        get :show, :id => @show_user
        response.should be_success
      end

      it "should have the right title" do
        get :show, :id => @show_user
        response.should have_selector("title", :content => "User Detail")
      end

      it "should display a delete button" do
        get :show, :id => @show_user
        response.should have_selector("a", :href => user_path(@show_user), :content => 'Delete')
      end

      it "should not display a delete button if you are viewing yourself" do
        get :show, :id => @admin_user
        response.should_not have_selector("a", :href => user_path(@admin_user), :content => 'Delete')
      end
    end
  end

  describe "GET 'index'" do
    before(:each) do
      @user1 = Factory(:user)
      @user2 = Factory(:user, :username => 'user2', :name => "Foo Bar")
      @user3 = Factory(:user, :username => 'user3', :name => "Baz Lupin")
    end

    describe 'for non-logged in users' do
      it "should deny access" do
        get :index
        response.should_not be_success
      end
    end

    describe "for non-admin users" do
      before(:each) do
        test_login(@user1)
      end

      it "should deny access" do
        get :index
        response.should_not be_success
      end
    end

    describe "for admin users" do
      before(:each) do
        @admin_user = test_login(Factory(:user, :username => 'admin'))
        @admin_user.roles = ["system admin"]
      end

      it "should allow access" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "Users")
      end

      it "should have links to all the users" do
        get :index
        response.should have_selector("a", :href => user_path(@user1), :content => @user1.username)
        response.should have_selector("a", :href => user_path(@user2), :content => @user2.username)
        response.should have_selector("a", :href => user_path(@user3), :content => @user3.username)
      end

      it "should have a link to the Users page in the users tools section" do
        get :index
        response.should have_selector("a", :content => "Users", :href => users_path)
      end

      it "should have a link to create new users" do
        get :index
        response.should have_selector("a", :href => new_user_path)
      end

    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @delete_user = Factory(:user)
    end

    describe "for non-users" do
      it "should deny access" do
        delete :destroy, :id => @delete_user
        response.should_not be_success
      end
    end

    describe "for non-admins" do
      before(:each) do
        test_login(Factory(:user, :username => 'user2'))
      end

      it "should deny access" do
        delete :destroy, :id => @delete_user
        response.should_not be_success
      end
    end

    describe "for admins" do
      before(:each) do
        @admin_user = test_login(Factory(:user, :username => 'admin'))
        @admin_user.roles = ["system admin"]
        test_login(@admin_user)
      end

      it "should destroy another user" do
        lambda do
          delete :destroy, :id => @delete_user
        end.should change(User, :count).by(-1)
      end

      it "should display a message on success" do
        delete :destroy, :id => @delete_user
        request.flash[:success] =~ /deleted/
      end

      it "should take you to the list of users on success" do
        delete :destroy, :id => @delete_user
        response.should redirect_to(users_path)
      end

      it "should not let you destroy yourself" do
        delete :destroy, :id => @admin_user
        response.should_not be_success
      end
    end
  end

  describe "GET 'new'" do
    describe "for non-users" do
      it "should deny access" do
        get :new
        response.should_not be_success
      end
    end

    describe "for non-admins" do
      before(:each) do
        test_login(Factory(:user))
      end

      it "should deny access" do
        get :new
        response.should_not be_success
      end
    end

    describe "for system-managers" do
      before(:each) do
        @system_manager_user = test_login(Factory(:user, :username => 'system_manager'))
        @system_manager_user.roles = ["system manager"]
      end

      it "should be success" do
        get :new
        response.should be_success
      end

      it "should not let them create a system admin user" do
        get :new
        response.should have_selector("input", :value=>"system admin", :disabled => 'disabled')
      end
    end

    describe "for admins" do
      before(:each) do
        @admin_user = test_login(Factory(:user, :username => 'admin'))
        @admin_user.roles = ["system admin"]
      end

      it "should be success" do
        get :new
        response.should be_success
      end

      it "should have the right title" do
        get :new
        response.should have_selector("title", :content => "Create New User")
      end
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @attrs = {:username => 'newuser', :password => 'foobar', :name => 'New User'}
    end

    describe "for non-users" do
      it "should deny access" do
        post :create, :user => @attrs
        response.should_not be_success
      end
    end

    describe "for non-admins" do
      before(:each) do
        test_login(Factory(:user))
      end

      it "should deny access" do
        post :create, :user => @attrs
        response.should_not be_success
      end
    end

    describe "for system managers" do
      before(:each) do
        @admin_user = test_login(Factory(:user, :username => 'admin'))
        @admin_user.roles = ["system manager"]
      end

      describe "failure" do
        it "should not create a new user" do
          lambda do
            post :create, :user => @attrs.merge(:username => ''), :roles => ['']
          end.should_not change(User, :count)
        end

        it "should render the form again" do
          post :create, :user => @attrs.merge(:username => ''), :roles => ['']
          response.should render_template('new')
        end
      end

      describe "success" do
        it "should create a new non-ldap user" do
          lambda do
            post :create, :user => @attrs, :roles => ['']
          end.should change(User, :count).by(1)
        end

        it "should create a new ldap user" do
          lambda do
            post :create, :user => @attrs.merge(:password =>''), :ldap => 'true', :roles => ['']
          end.should change(User, :count).by(1)
        end

        it "should redirect to the user detail page" do
          post :create, :user => @attrs, :roles => ['']
          response.should redirect_to(user_path(assigns(:user)))
        end
      end
    end
  end

end
