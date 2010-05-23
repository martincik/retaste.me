require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe ReportsController do
  describe "with #index" do
    before(:each) do
      Delicious.any_instance.stubs(:validate_account).returns(true)
      Report.delete_all
      @user = login_as
    end
    
    it "shows rendered report as HTML"  do
      delicious = Factory(:delicious, :user => @user)
      Factory(:report, :user => @user, :service => delicious)
      Report.any_instance.stubs(:from_html).returns('html')
      
      get :show, :week => Date.today.cweek, :year => Date.today.year
      
      response.should be_success
    end
    
    it "shows error message (flash) if no report exists and redirect to root" do
      get :show, :week => Date.today.cweek, :year => Date.today.year
      
      response.should be_redirect
      response.should redirect_to(root_path)
    end
    
    it "shows error message (flash) if report exists but HTML file doesn't" do
      delicious = Factory(:delicious, :user => @user)
      Factory(:report, :user => @user, :service => delicious)
      
      get :show, :week => Date.today.cweek, :year => Date.today.year
      
      response.should be_redirect
      response.should redirect_to(root_path)
    end
    
    it "shows error message (flash) if report doesn't exists for current user" do
      delicious = Factory(:delicious, :user => @user)
      Factory(:report, :user => Factory(:user), :service => delicious)
      
      get :show, :week => Date.today.cweek, :year => Date.today.year
      
      response.should be_redirect
      response.should redirect_to(root_path)
    end
    
  end
end
