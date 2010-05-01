require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Delicious do
  
  before(:each) do
    Context.reset
    @user = Factory(:user)
  end
  
  it "to be valid requires assigned login and password" do
    delicious = Delicious.new(:user => @user)
    delicious.valid?.should be_false
    delicious.errors.on(:login).should == "can't be blank"
    delicious.errors.on(:password).should == "can't be blank"
    delicious.login = 'login'
    delicious.password = 'password'
    delicious.valid?.should be_true
  end
  
  it "will save valid object to database" do
    delicious = Delicious.new(:user => @user, :login => 'login', :password => 'password')
    delicious.valid?.should be_true
    delicious.save.should be_true
    delicious.new_record?.should be_false
  end

end
