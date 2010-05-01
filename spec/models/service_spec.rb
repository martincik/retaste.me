require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Service do
  
  before(:each) do
    Context.reset
    @user = Factory(:user)
  end
  
  it "to be valid requires assigned user" do
    service = Service.new
    service.valid?.should be_false
    service.user = @user
    service.valid?.should be_true
  end
  
  it "can not be saved because it's abstract class" do
    service = Service.new(:user => @user)
    service.valid?.should be_true
    service.save.should be_false
    service.new_record?.should be_true
  end

end
