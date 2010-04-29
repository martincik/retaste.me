require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Context do
  
  before(:each) do
    Context.reset
    @user = Factory(:user)
  end
  
  it "should recognize user from session" do
    Context.setup({}, { :user_id => @user.id }, {})
    Context.user.should == @user
  end

end
