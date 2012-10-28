require 'spec_helper'

describe ListsController do
  render_views

  before(:each) do
    @school1 = Factory(:school, :name => "Test School A")
    @school2 = Factory(:school, :name => "Test School B")
    @list_creator = Factory(:user, :username => "ListCreator")
    @list_creator.roles = ['system admin']
    @list1 = Factory(:list, :name => "Test List A", :user => @list_creator, :school_id => nil)
    @list2 = Factory(:list, :name => "Test List B", :user => @list_creator, :school_id => nil)
    @list3 = Factory(:list, :name => "Test List C", :user => @list_creator, :school => @school1)
    @list4 = Factory(:list, :name => "Test List D", :user => @list_creator, :school => @school2)
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
        user.roles = ['full sender']
        get :index
        response.should redirect_to(login_path)
      end
    end

    describe "for location managers of one school" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        user.message_permissions.create!({:object_id => @school1.id, :object_type => 'School'})
      end

      it "should allow access" do
        get :index
        response.should be_success
      end

      it "should list only the lists for this person's school" do
        get :index
        response.should have_selector("a", :content => @list3.name, :href => list_path(@list3))
        response.should_not have_selector("a", :content => @list1.name, :href => list_path(@list1))
        response.should_not have_selector("a", :content => @list2.name, :href => list_path(@list2))
        response.should_not have_selector("a", :content => @list4.name, :href => list_path(@list4))
      end

      it "should have a 'create new list' link" do
        get :index
        response.should have_selector("a", :content => "Create New List", :href => new_list_path)
      end
    end

    describe "for location managers of multiple schools" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        user.message_permissions.create!({:object_id => @school1.id, :object_type => 'School'})
        user.message_permissions.create!({:object_id => @school2.id, :object_type => 'School'})
      end

      it "should allow access" do
        get :index
        response.should be_success
      end

      it "should list only the lists for this person's school" do
        get :index
        response.should have_selector("a", :content => @list3.name, :href => list_path(@list3))
        response.should_not have_selector("a", :content => @list1.name, :href => list_path(@list1))
        response.should_not have_selector("a", :content => @list2.name, :href => list_path(@list2))
        response.should have_selector("a", :content => @list4.name, :href => list_path(@list4))
      end

      it "should have a 'create new list' link" do
        get :index
        response.should have_selector("a", :content => "Create New List", :href => new_list_path)
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

      it "should list all the lists" do
        get :index
        response.should have_selector("a", :content => @list3.name, :href => list_path(@list3))
        response.should have_selector("a", :content => @list1.name, :href => list_path(@list1))
        response.should have_selector("a", :content => @list2.name, :href => list_path(@list2))
        response.should have_selector("a", :content => @list4.name, :href => list_path(@list4))
      end

      it "should have a 'create new list' link" do
        get :index
        response.should have_selector("a", :content => "Create New List", :href => new_list_path)
      end
    end

    describe "for system admins" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system admin']
      end

      it "should allow access" do
        get :index
        response.should be_success
      end

      it "should list all the lists" do
        get :index
        response.should have_selector("a", :content => @list3.name, :href => list_path(@list3))
        response.should have_selector("a", :content => @list1.name, :href => list_path(@list1))
        response.should have_selector("a", :content => @list2.name, :href => list_path(@list2))
        response.should have_selector("a", :content => @list4.name, :href => list_path(@list4))
      end

      it "should have a 'create new list' link" do
        get :index
        response.should have_selector("a", :content => "Create New List", :href => new_list_path)
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

    describe "for location managers of one school" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        user.message_permissions.create!({:object_id => @school1.id, :object_type => 'School'})
      end

      it "should allow access" do
        get :new
        response.should be_success
      end

      it "should list only the one school" do
        get :new
        response.should have_selector("option", :content => @school1.name, :value => @school1.id.to_s)
        response.should_not have_selector("option", :content => @school2.name, :value => @school2.id.to_s)
        response.should_not have_selector("option", :content => "No School")
      end
    end

    describe "for location managers of multiple schools" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        user.message_permissions.create!({:object_id => @school1.id, :object_type => 'School'})
        user.message_permissions.create!({:object_id => @school2.id, :object_type => 'School'})
      end

      it "should allow access" do
        get :new
        response.should be_success
      end

      it "should list only the user's schools" do
        get :new
        response.should have_selector("option", :content => @school1.name, :value => @school1.id.to_s)
        response.should have_selector("option", :content => @school2.name, :value => @school2.id.to_s)
        response.should_not have_selector("option", :content => "No School")
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

      it "should list all the schools and allow no school" do
        get :new
        response.should have_selector("option", :content => @school1.name, :value => @school1.id.to_s)
        response.should have_selector("option", :content => @school2.name, :value => @school2.id.to_s)
        response.should have_selector("option", :content => "Not School Specific")
      end
    end

    describe "for system admins" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system admin']
      end

      it "should allow access" do
        get :new
        response.should be_success
      end

      it "should list all the schools and allow no school" do
        get :new
        response.should have_selector("option", :content => @school1.name, :value => @school1.id.to_s)
        response.should have_selector("option", :content => @school2.name, :value => @school2.id.to_s)
        response.should have_selector("option", :content => "Not School Specific")
      end
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @attrs = {:name => 'Test List', :description => 'This is my test list'}
    end

    describe "for non-users" do
      it "should deny access" do
        post :create, :list => @attrs
        response.should_not be_success
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['full sender']
        post :create, :list => @attrs
        response.should_not be_success
      end
    end

    describe "for location managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        user.message_permissions.create!({:object_id => @school1.id, :object_type => 'School'})
      end

      describe "failure" do
        it "should not create a new list" do
          lambda do
            post :create, :list => @attrs.merge(:name => '  ', :school_id => @school1.id)
          end.should_not change(List, :count)
        end

        it "should render the form again" do
          post :create, :list => @attrs.merge(:name => '  ', :school_id => @school1.id)
          response.should render_template('new')
        end
      end

      describe "success" do
        it "should create a new list" do
          lambda do
            post :create, :list => @attrs.merge(:school_id => @school1.id)
          end.should change(List, :count).by(1)
        end

        it "should redirect to the lists page" do
          post :create, :list => @attrs.merge(:school_id => @school1.id)
          response.should redirect_to(lists_path)
        end
      end
    end
  end

  describe "GET 'show'" do
    describe "for non-users" do
      it "should deny access" do
        get :show, :id => @list1
        response.should redirect_to(login_path)
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['full sender']
        get :show, :id => @list1
        response.should redirect_to(login_path)
      end
    end

    describe "for location managers of one school" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        user.message_permissions.create!({:object_id => @school1.id, :object_type => 'School'})
      end

      it "should allow access for lists from the correct school" do
        get :show, :id => @list3
        response.should be_success
      end

      it "should deny access for lists from the wrong schools" do
        get :show, :id => @list1
        response.should_not be_success
        get :show, :id => @list2
        response.should_not be_success
        get :show, :id => @list4
        response.should_not be_success
      end

      it "should list only the one school" do
        get :show, :id => @list3
        response.should have_selector("option", :content => @school1.name, :value => @school1.id.to_s)
        response.should_not have_selector("option", :content => @school2.name, :value => @school2.id.to_s)
        response.should_not have_selector("option", :content => "No School")
      end
    end

    describe "for location managers of multiple schools" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        user.message_permissions.create!({:object_id => @school1.id, :object_type => 'School'})
        user.message_permissions.create!({:object_id => @school2.id, :object_type => 'School'})
      end

      it "should allow access for lists from the correct schools" do
        get :show, :id => @list3
        response.should be_success
        get :show, :id => @list4
        response.should be_success
      end

      it "should deny access for lists from the wrong schools" do
        get :show, :id => @list1
        response.should_not be_success
        get :show, :id => @list2
        response.should_not be_success
      end

      it "should list only the user's schools" do
        get :show, :id => @list4
        response.should have_selector("option", :content => @school1.name, :value => @school1.id.to_s)
        response.should have_selector("option", :content => @school2.name, :value => @school2.id.to_s)
        response.should_not have_selector("option", :content => "No School")
      end
    end

    describe "for system managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system manager']
      end

      it "should allow access for lists from all schools" do
        get :show, :id => @list1
        response.should be_success
        get :show, :id => @list2
        response.should be_success
        get :show, :id => @list3
        response.should be_success
        get :show, :id => @list4
        response.should be_success
      end

      it "should list all the schools and allow no school" do
        get :show, :id => @list1
        response.should have_selector("option", :content => @school1.name, :value => @school1.id.to_s)
        response.should have_selector("option", :content => @school2.name, :value => @school2.id.to_s)
        response.should have_selector("option", :content => "Not School Specific")
      end
    end

    describe "for system admins" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system admin']
      end

      it "should allow access for lists from all schools" do
        get :show, :id => @list1
        response.should be_success
        get :show, :id => @list2
        response.should be_success
        get :show, :id => @list3
        response.should be_success
        get :show, :id => @list4
        response.should be_success
      end

      it "should list all the schools and allow no school" do
        get :show, :id => @list1
        response.should have_selector("option", :content => @school1.name, :value => @school1.id.to_s)
        response.should have_selector("option", :content => @school2.name, :value => @school2.id.to_s)
        response.should have_selector("option", :content => "Not School Specific")
      end
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @attrs = {:name => 'New List Name'}
    end

    describe "for non-users" do
      it "should deny access" do
        put :update, :id => @list3, :list => @attrs
        response.should_not be_success
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['full sender']
        put :update, :id => @list3, :list => @attrs
        response.should_not be_success
      end
    end

    describe "for location managers of one school" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        user.message_permissions.create!({:object_id => @school1.id, :object_type => 'School'})
      end

      it "should deny access for other schools" do
        put :update, :id => @list1, :list => @attrs
        response.should_not be_success
        put :update, :id => @list2, :list => @attrs
        response.should_not be_success
        put :update, :id => @list4, :list => @attrs
        response.should_not be_success
      end

      describe "failure" do
        it "should render the form again" do
          put :update, :id => @list3, :list => @attrs.merge(:name => '  ')
          response.should render_template('show')
        end
      end

      describe "success" do
        it "should redirect to the lists page" do
          put :update, :id => @list3, :list => @attrs
          response.should redirect_to lists_path
        end

        it "should update the list info" do
          put :update, :id => @list3, :list => @attrs
          @list3.reload
          (@list3.name == @attrs[:name]).should be_true
        end
      end
    end

    describe "for location managers of multiple schools" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        user.message_permissions.create!({:object_id => @school1.id, :object_type => 'School'})
        user.message_permissions.create!({:object_id => @school2.id, :object_type => 'School'})
      end

      it "should deny access for other schools" do
        put :update, :id => @list1, :list => @attrs
        response.should_not be_success
        put :update, :id => @list2, :list => @attrs
        response.should_not be_success
      end

      describe "failure" do
        it "should render the form again" do
          put :update, :id => @list4, :list => @attrs.merge(:name => '  ')
          response.should render_template('show')
        end
      end

      describe "success" do
        it "should redirect to the lists page" do
          put :update, :id => @list4, :list => @attrs
          response.should redirect_to lists_path
        end

        it "should update the list info" do
          put :update, :id => @list4, :list => @attrs
          @list4.reload
          (@list4.name == @attrs[:name]).should be_true
        end
      end
    end

    describe "for system managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system manager']
      end

      describe "failure" do
        it "should render the form again" do
          put :update, :id => @list1, :list => @attrs.merge(:name => '  ')
          response.should render_template('show')
        end
      end

      describe "success" do
        it "should redirect to the lists page" do
          put :update, :id => @list1, :list => @attrs
          response.should redirect_to lists_path
        end

        it "should update the list info" do
          put :update, :id => @list1, :list => @attrs
          @list1.reload
          (@list1.name == @attrs[:name]).should be_true
        end
      end
    end

    describe "for system admins" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system admin']
      end

      describe "failure" do
        it "should render the form again" do
          put :update, :id => @list2, :list => @attrs.merge(:name => '  ')
          response.should render_template('show')
        end
      end

      describe "success" do
        it "should redirect to the lists page" do
          put :update, :id => @list2, :list => @attrs
          response.should redirect_to lists_path
        end

        it "should update the list info" do
          put :update, :id => @list2, :list => @attrs
          @list2.reload
          (@list2.name == @attrs[:name]).should be_true
        end
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for non-users" do
      it "should deny access" do
        delete :destroy, :id => @list1
        response.should_not be_success
        delete :destroy, :id => @list2
        response.should_not be_success
        delete :destroy, :id => @list3
        response.should_not be_success
        delete :destroy, :id => @list4
        response.should_not be_success
      end
    end

    describe "for regular users" do
      it "should deny access" do
        user = test_login(Factory(:user))
        user.roles = ['full sender']
        delete :destroy, :id => @list1
        response.should_not be_success
        delete :destroy, :id => @list2
        response.should_not be_success
        delete :destroy, :id => @list3
        response.should_not be_success
        delete :destroy, :id => @list4
        response.should_not be_success
      end
    end

    describe "for location managers for one school" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        user.message_permissions.create!({:object_id => @school1.id, :object_type => 'School'})
      end

      it "should deny access for lists from wrong school" do
        delete :destroy, :id => @list1
        response.should_not be_success
        delete :destroy, :id => @list2
        response.should_not be_success
        delete :destroy, :id => @list4
        response.should_not be_success
      end

      it "should destroy the list" do
        lambda do
          delete :destroy, :id => @list3
        end.should change(List, :count).by(-1)
      end
    end

    describe "for location managers for multiple schools" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['location manager']
        user.message_permissions.create!({:object_id => @school1.id, :object_type => 'School'})
        user.message_permissions.create!({:object_id => @school2.id, :object_type => 'School'})
      end

      it "should deny access for lists from wrong school" do
        delete :destroy, :id => @list1
        response.should_not be_success
        delete :destroy, :id => @list2
        response.should_not be_success
      end

      it "should destroy the list" do
        lambda do
          delete :destroy, :id => @list4
        end.should change(List, :count).by(-1)
      end
    end

    describe "for system managers" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system manager']
      end

      it "should destroy the list" do
        lambda do
          delete :destroy, :id => @list2
        end.should change(List, :count).by(-1)
      end

      it "should redirect to the list index page" do
        delete :destroy, :id => @list2
        response.should redirect_to lists_path
      end
    end

    describe "for system admins" do
      before(:each) do
        user = test_login(Factory(:user))
        user.roles = ['system admin']
      end

      it "should destroy the list" do
        lambda do
          delete :destroy, :id => @list1
        end.should change(List, :count).by(-1)
      end

      it "should redirect to the list index page" do
        delete :destroy, :id => @list1
        response.should redirect_to lists_path
      end
    end
  end
end
