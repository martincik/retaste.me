require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Delicious do
  
  before(:each) do
    Context.reset
    @user = Factory(:user)
  end
  
  it "to be valid requires assigned login and password" do
    Delicious.any_instance.stubs(:validate_account).returns(true)
    delicious = Delicious.new(:user => @user)
    delicious.valid?.should be_false
    delicious.errors.on(:login).should == "can't be blank"
    delicious.errors.on(:password).should == "can't be blank"
    delicious.login = 'login'
    delicious.password = 'password'
    delicious.valid?.should be_true
  end
  
  it "will save valid object to database" do
    Delicious.any_instance.stubs(:validate_account).returns(true)
    delicious = Delicious.new(:user => @user, :login => 'login', :password => 'password')
    delicious.valid?.should be_true
    delicious.save.should be_true
    delicious.new_record?.should be_false
  end
  
  it "doesn't allow save delicious settings if delicous.com validation pass" do
    WWW::Delicious.stubs(:new).returns(mock('del') do
      expects(:valid_account?).at_least(2).returns(false)
    end)
    delicious = Delicious.new(:user => @user, :login => 'login', :password => 'password')
    delicious.valid?.should be_false
    delicious.save.should be_false
    delicious.new_record?.should be_true
  end

end
