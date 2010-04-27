require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe ProfileController do

  before(:each) do
    @user = login_as
  end

  describe "GET edit" do
    it "assigns the requested user as @user from Context.user" do
      get :edit
      assigns[:user].id.should equal(@user.id)
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested user" do
        put :update, :user => { :username => 'change' }
        assigns[:user].username.should == 'change'
        response.should render_template('profile/edit')
      end

      it "updates the requested user with JSON" do
        put :update, :user => { :username => "change" }, :format => 'json'
        response.should be_success
        response.body.should be_blank
      end

      it "renders edit page if something isn't valid" do
        put :update, :user => { :username => '' }
        response.should render_template('profile/edit')
      end
      
      it "renders edit page if something isn't valid" do
        put :update, :user => { :username => '' }, :format => 'json'
        user_json = JSON.parse(response.body)
        user_json.length.should == 1
        user_json = Hash[*user_json.flatten]
        user_json["username"].should == "can't be blank"
      end
    end

  end
  
  describe "POST create" do

     it "create the requested user with email" do
       put :create, :user => { :email => 'petr@zaparka.cz' }
       assigns[:user].email.should == 'petr@zaparka.cz'
       response.should redirect_to(root_path)
     end
     
     it "create the requested user with email for JSON" do
        put :create, :user => { :email => 'petr@zaparka.cz' }, :format => 'json'
        response.should be_success
        response.body.should be_blank
      end
     
      it "will not create the requested user if email address missing" do
        put :create, :user => { :email => '' }
        assigns[:user].errors.on(:email).should == 'can\'t be blank'
        response.should render_template('profile/new')
      end
      
      it "will not create the requested user if email address missing" do
        put :create, :user => { :email => '' }, :format => 'json'
        user_json = JSON.parse(response.body)
        user_json.length.should == 1
        user_json = Hash[*user_json.flatten]
        user_json["email"].should == "can't be blank"
      end
     
  end
  
  describe "GET new" do
    
    it "create the requested user with email" do
      put :new
      response.should render_template('profile/new')
    end
     
  end
end
