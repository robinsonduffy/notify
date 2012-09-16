require 'spec_helper'

describe PagesController do
  render_views
  describe "Home Page" do

    describe "for logged out users" do
      it "should deny access" do
        get :home
        response.should redirect_to(login_path)
      end
    end

    describe "for logged in users" do
      before(:each) do
        @user = test_login(Factory(:user))
      end

      it "should allow access" do
        get :home
        response.should be_success
      end

      it "should have the right title" do
        get :home
        response.should have_selector("title", :content => "Notification App")
      end

      it "should have a home link" do
        get :home
        response.should have_selector("a", :href => root_path)
      end
      
      it "should have a logout link" do
        get :home
        response.should have_selector("a", :href => logout_path)
      end
      
      it "should not have a users link" do
        get :home
        response.should_not have_selector("a", :href => users_path)
      end
      
    end

    describe "for admin users" do
      before(:each) do
        test_login(Factory(:user, :username => 'admin', :roles => ["admin"]))
      end

      it "should have a users link" do
        get :home
        response.should have_selector("a", :href => users_path)
      end
    end

  end
end
