require 'spec_helper'

describe SessionsController do
  render_views
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Login")
    end
  end

  describe "POST 'create'" do

    describe "invalid login" do
      before(:each) do
        @attr = {:username => "UserName", :password => 'wrongpassword'}
      end

      it "should render the login form again" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector("title", :content => "Login")
      end

      it "should display an error message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end

    describe "valid login" do
      before(:each) do
        @user = Factory(:user, :username => 'user', :password => 'foobar')
        @attr = {:username => 'user', :password => 'foobar'}
      end

      it "should sign the user in" do
        post :create, :session => @attr
        controller.current_user.should == @user
        ability = Ability.new(@user)
        ability.should be_able_to(:view, :protected_content)
      end
    end

    describe "ldap" do
      before(:each) do
        #enter in a valid ldap username and password here
        @attr = {:username => 'LDAPUSERNAME', :password => 'LDAPUSERPASSWORD'}
        @ldap_user_name = "LDAPUSERDISPLAYNAME"
      end

      xit "should deny access if ldap password is wrong" do
        post :create, :session => @attr.merge(:password => 'wrongpassword')
        response.should render_template('new')
        flash.now[:error].should =~ /invalid/i
      end

      xit "should create a user on first log in" do
        lambda do
          post :create, :session => @attr
          User.find_by_username(@attr[:username]).should_not be_nil
          controller.current_user.should == User.find_by_username(@attr[:username])
          controller.should be_logged_in
        end.should change(User, :count).by(1)
      end


      xit "should copy over the user info from ldap for new users" do
        post :create, :session => @attr
        ldap_user = User.find_by_username(@attr[:username])
        ldap_user.password.should == 'ldap'
        ldap_user.name.should == @ldap_user_name
      end

      xit "should copy over the user info from ldap for existing users" do
        premade_ldap_user = Factory(:user, :username => @attr[:username], :password => 'ldap')
        post :create, :session => @attr
        ldap_user = User.find_by_username(@attr[:username])
        ldap_user.should == premade_ldap_user
        ldap_user.password.should == 'ldap'
        ldap_user.name.should == @ldap_user_name
      end

      xit "should log an existing user in with ldap credentials" do
        ldap_user = Factory(:user, :username => @attr[:username], :password => 'ldap')
        post :create, :session => @attr
        controller.current_user.should == ldap_user
        controller.should be_logged_in
      end
    end
  end

  describe "DELETE 'destroy'" do

    it "should sign a user out" do
      test_login(Factory(:user))
      delete :destroy
      ability = Ability.new(@user)
      ability.should_not be_able_to(:view, :protected_content)
      response.should redirect_to(login_path)
    end
    
  end

end
