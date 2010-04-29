require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe ApplicationHelper do
  include ApplicationHelper
  
  it "selects tab for navigation" do
    select_current_tab('accounts', 'accounts').should == ' class="selected"'
  end
  
  it "return formated title" do
   formated_title = title('Hello World', :h2)
   formated_title.should == '<h2>Hello World</h2>'
  end
  
  it "return flash messages" do
    flash[:notice] = "buuug"
    msg = flash_messages
    msg.count == 1
    msg.first.should == "<div id=\"flash-notice\">buuug</div>"
  end
  
  it "don't return flash messages" do
    msg = flash_messages
    msg.count == 0
    msg.first.should be_blank
  end
  
  it "does not selects tab for navigation if not the same" do
    select_current_tab('different', 'accounts').should == ''
  end
    
end
