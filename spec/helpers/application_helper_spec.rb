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
  
  it "return context link" do
    links = context_links(link_to('account', 'http:\\link_to_menu'))
    links.first.should == '<span><a href="http:\\link_to_menu">account</a></span>'
  end
  
  it "return context links" do
    links = context_links(link_to('account', 'http:\\link_to_menu'),link_to('transactions', 'http:\\link_to_submenu'))
    links.first.should == '<span><a href="http:\\link_to_menu">account</a>&nbsp;&raquo;&nbsp;</span>'
    links.second.should == '<span><a href="http:\\link_to_submenu">transactions</a></span>'
  end
  
  it "return shorted text" do
    text = "This is test of text shortening."
    shortened_text = shorten(text, 16, ' etc.')
    shortened_text.should == "This is test etc."
    shortened_text = shorten(text, 50)
    shortened_text.should == text
  end
  
  it "return properly formated currency with decimal point" do
    amount_with_currency = format_currency(222)
    amount_with_currency.should == "&euro;222.00"
  end
  
  it "return currency with properly formated decimal point" do
    amount_with_currency = format_currency('222.3')
    amount_with_currency.should == "&euro;222.30"
  end  
    
end
