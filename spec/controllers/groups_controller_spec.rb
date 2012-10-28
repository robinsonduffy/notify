require 'spec_helper'

describe GroupsController do
  render_views

  before(:each) do
    group_creator = Factory(:user, :username => "CreateGroup")
    @group1 = Factory(:group, :name => "Test Group 1", :user => group_creator)
    @group2 = Factory(:group, :name => "Test Group 2", :user => group_creator)
  end

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
        user.roles = ['location manager']
        get :index
        response.should redirect_to(login_path)
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

      it "should list the groups" do
        get :index
        response.should have_selector("a", :content => @group1.name, :href => group_path(@group1))
        response.should have_selector("a", :content => @group2.name, :href => group_path(@group2))
      end

      it "should have a 'create new group' link" do
        get :index
        response.should have_selector("a", :content => "Create New Group", :href => new_group_path)
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

    describe "for recipient managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['recipient manager']
      end

      it "should allow access" do
        get :index
        response.should be_success
      end
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @attrs = {:name => 'New Group'}
    end

    describe "for non-users" do
      it "should deny access" do
        post :create, :group => @attrs
        response.should_not be_success
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        post :create, :group => @attrs
        response.should_not be_success
      end
    end

    describe "for recipient managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['recipient manager']
      end

      describe "failure" do
        it "should not create a new group" do
          lambda do
            post :create, :group => @attrs.merge(:name => '  ')
          end.should_not change(Group, :count)
        end

        it "should render the form again" do
          post :create, :group => @attrs.merge(:name => '  ')
          response.should render_template('new')
        end
      end

      describe "success" do
        it "should create a new group" do
          lambda do
            post :create, :group => @attrs
          end.should change(Group, :count).by(1)
        end

        it "should redirect to the groups list page" do
          post :create, :group => @attrs
          response.should redirect_to(groups_path)
        end
      end
    end
  end

  describe "GET 'show'" do

    describe "for non-users" do
      it "should deny access" do
        get :show, :id => @group1
        response.should redirect_to(login_path)
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        get :show, :id => @group1
        response.should redirect_to(login_path)
      end
    end

    describe "for recipient managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['recipient manager']
      end

      it "should allow access" do
        get :show, :id => @group1
        response.should be_success
      end
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @attrs = {:name => 'Changed Group Name'}
    end

    describe "for non-users" do
      it "should deny access" do
        put :update, :id => @group1, :group => @attrs
        response.should_not be_success
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        put :update, :id => @group1, :group => @attrs
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
          put :update, :id => @group1, :group => @attrs.merge(:name => '  ')
          response.should render_template('show')
        end
      end

      describe "success" do
        it "should redirect to the groups list page" do
          put :update, :id => @group1, :group => @attrs
          response.should redirect_to groups_path
        end

        it "should update the group info" do
          put :update, :id => @group1, :group => @attrs
          @group1.reload
          (@group1.name == @attrs[:name]).should be_true
        end
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for non-users" do
      it "should deny access" do
        delete :destroy, :id => @group1
        response.should_not be_success
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        delete :destroy, :id => @group1
        response.should_not be_success
      end
    end

    describe "for recipient managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['recipient manager']
      end

      it "should destroy the group" do
        lambda do
          delete :destroy, :id => @group1
        end.should change(Group, :count).by(-1)
      end

      it "should redirect to the group index page" do
        delete :destroy, :id => @group1
        response.should redirect_to groups_path
      end
    end
  end
end
