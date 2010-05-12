require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Report do

  before(:each) do
    Delicious.any_instance.stubs(:validate_account).returns(true)
  end
  
  describe "reading generated report" do
  
    before(:each) do
      @user = Factory(:user)
      @delicious = Factory(:delicious, :user => @user)
      @report = Factory(:report, :user => @user, :service => @delicious)
      Report.any_instance.stubs(:presence_of_html_file)
    end
  
    it "is idetifiable by composed_id" do
      @report.composed_id.should == "#{@user.id}_#{@delicious.id}_#{Date.today.cweek}_#{Date.today.year}"
    end
  
    it "throws exceptions if trying to read HTML file but it doesn't exists" do
      lambda { @report.from_html }.should raise_error(ActiveRecord::RecordNotFound)
    end
  
    it "returns content of HTML file if exists calling from_html()" do
      @report.stubs(:report_file_path).returns(File.join(RAILS_ROOT, 'spec', 'fixtures', 'reports', 'html_file'))
      @report.from_html.should == 'HTML'
    end
    
  end
  
  describe "generate reports for current week" do
    
    before(:each) do
      @user = Factory(:user)
      @delicious = Factory(:delicious, :user => @user)
      @another_user = Factory(:user, :username => 'another.user')
      Report.any_instance.stubs(:to_html)
    end
    
    it "for every user and sents email" do
      another_delicious = Factory(:delicious, :user => @another_user)
      
      NotifierMailer.expects(:deliver_successfully_generated_reports)
      Report.generate_reports_for_current_week.should == []
    end
    
    it "for every user tries to generate report and sents email with the failed once" do
      another_delicious = Factory(:delicious, :user => @another_user)
      another_delicious.expects(:generate_current_week_report).returns(mock(:to_html => true, :save => false, :errors => 'errors'))
      @another_user.expects(:delicious).returns(another_delicious)

      User.expects(:all).returns([@another_user, @user])

      NotifierMailer.expects(:deliver_broken_reports)
      Report.generate_reports_for_current_week.length.should == 1
    end
    
    it "for every user tries to generate report and sents email with the failed once because of to_html exception" do
      Report.any_instance.expects(:to_html).raises(Exception.new)
      
      another_delicious = Factory(:delicious, :user => @another_user)
      another_delicious.expects(:generate_current_week_report).returns(Report.new)
      @another_user.expects(:delicious).returns(another_delicious)

      User.expects(:all).returns([@another_user, @user])

      NotifierMailer.expects(:deliver_broken_reports)
      num_reports = Report.count
      Report.generate_reports_for_current_week.length.should == 1
      Report.count.should == num_reports + 1
    end
    
  end
  
end
