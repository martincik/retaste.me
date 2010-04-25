require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe UserSessionsController do
  
  before do 
    User.destroy_all
  end

  it "provides page with login access" do
    get :new
    response.should be_success
    response.should render_template("new")
  end

  it "redirects back to login if RPXNow returns nil data" do
    RPXNow.expects(:user_data).returns(nil)

    post :create
    response.should be_redirect
    response.should redirect_to(login_path)
  end

  it "let user to login if already exists in database and RPXNow is successfull" do
    user = Factory(:user)
    RPXNow.expects(:user_data).returns(Factory.attributes_for(:user))

    post :create
    session[:user_id].should == user.id
    response.should be_redirect
    response.should redirect_to(root_path)
    user.destroy
  end

  it "will create user if user successfully logged in but doesn't exists yet in database" do
    RPXNow.expects(:user_data).returns(Factory.attributes_for(:user))

    post :create
    session[:user_id].should_not be_nil
    response.should be_redirect
    response.should redirect_to(root_path)
  end

  it "will inform user about already existing email address if login with different service" do
    user = Factory.create(:user)
    RPXNow.expects(:user_data).returns(Factory.attributes_for(:user, :email => user.email, :identifier => 'new_identification'))

    post :create
    session[:user_id].should be_nil
    flash[:notice].should == I18n.t('controller.user_sessions.create.notice')
    response.should be_redirect
    response.should redirect_to(login_path)
    user.destroy
  end

  it "will not store user id in the session if user creation fails for some reason" do
    RPXNow.expects(:user_data).returns(Factory.attributes_for(:user))
    @user = stub(:new_record? => true, :email => 'petr@zaparka.cz')
    User.expects(:create).returns(@user)

    post :create
    session[:user_id].should be_nil
    response.should be_redirect
    response.should redirect_to(root_path)
  end

  it "will not store user id in the session if user creation fails for some reason" do
    RPXNow.expects(:user_data).returns(Factory.attributes_for(:user))
    @user = stub(:id => 1, :new_record? => false, :email => '')
    User.expects(:create).returns(@user)

    post :create
    session[:user_id].should_not be_nil
    response.should be_redirect
    response.should redirect_to(new_profile_path)
  end

  it "allows user to logout and redirect him back to login" do
    session[:user_id] = Factory(:user).id

    post :destroy
    session[:user_id].should be_nil
    response.should be_redirect
    response.should redirect_to(login_path)
  end

end