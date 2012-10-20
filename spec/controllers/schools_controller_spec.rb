require 'spec_helper'

describe SchoolsController do
  render_views

  describe "GET 'index'" do
    before(:each) do
      @school1 = Factory(:school, :name => "Test School 1")
      @school2 = Factory(:school, :name => "Test School 2")
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

      it "should list the schools" do
        get :index
        response.should have_selector("a", :content => @school1.name, :href => school_path(@school1))
        response.should have_selector("a", :content => @school2.name, :href => school_path(@school2))
      end

      it "should have a 'create new school' link" do
        get :index
        response.should have_selector("a", :content => "Create New School", :href => new_school_path)
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
        get :index
        response.should be_success
      end
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @attrs = {:name => 'Test School 1'}
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
            post :create, :school => @attrs.merge(:name => '  ')
          end.should_not change(School, :count)
        end

        it "should render the form again" do
          post :create, :school => @attrs.merge(:name => '  ')
          response.should render_template('new')
        end
      end

      describe "success" do
        it "should create a new school" do
          lambda do
            post :create, :school => @attrs
          end.should change(School, :count).by(1)
        end

        it "should redirect to the school detail page" do
          post :create, :school => @attrs
          response.should redirect_to(school_path(assigns(:school)))
        end
      end
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @school = Factory(:school)
    end

    describe "for non-users" do
      it "should deny access" do
        get :show, :id => @school
        response.should redirect_to(login_path)
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        get :show, :id => @school
        response.should redirect_to(login_path)
      end
    end

    describe "for system managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system manager']
      end

      it "should allow access" do
        get :show, :id => @school
        response.should be_success
      end
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @school = Factory(:school)
      @attrs = {:name => 'New School Name'}
    end

    describe "for non-users" do
      it "should deny access" do
        put :update, :id => @school, :school => @attrs
        response.should_not be_success
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        put :update, :id => @school, :school => @attrs
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
          put :update, :id => @school, :school => @attrs.merge(:name => '  ')
          response.should render_template('show')
        end
      end

      describe "success" do
        it "should redirect to the school detail page" do
          put :update, :id => @school, :school => @attrs
          response.should redirect_to school_path(@school)
        end

        it "should update the school info" do
          put :update, :id => @school, :school => @attrs
          @school.reload
          (@school.name == @attrs[:name]).should be_true
        end
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @school = Factory(:school)
    end

    describe "for non-users" do
      it "should deny access" do
        delete :destroy, :id => @school
        response.should_not be_success
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        delete :destroy, :id => @school
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
          delete :destroy, :id => @school
        end.should change(School, :count).by(-1)
      end

      it "should redirect to the school index page" do
        delete :destroy, :id => @school
        response.should redirect_to schools_path
      end
    end
  end
end
