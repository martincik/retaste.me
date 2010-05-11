require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe NotifierMailer do
  
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = 'utf-8'
  
  before(:each) do
    @expected = TMail::Mail.new
    @expected.set_content_type 'text', 'plain', { 'charset' => CHARSET }
    @expected.mime_version = '1.0'
    Delicious.any_instance.stubs(:validate_account).returns(true)
  end
  
  it "should send email to administrator about broken reports" do
    @expected.subject = "[retaste.me] [REPORT] [BROKEN] - #{Date.today.to_s}"
    @expected.body    = read_fixture('broken_reports')
    @expected.from    = 'no-reply@retaste.me'
    @expected.to      = 'ladislav.martincik@gmail.com'
    
    user = Factory(:user)
    service = Factory(:delicious, :user => user)
    report = mock('report', :year => 2010, :week => 1, 
      :user => user, :service => service,
      :errors => mock('errors', :full_messages => 'full_messages') )
    response = NotifierMailer.create_broken_reports([report], 2)
    response.body.should == "<h1>Notification from retaste.me:</h1>\n\n<h2>Generated records: 2</h2>\n<br />\n\n<h2>These reports are broken:</h2>\n<br />\n\n<p>\n  user ID: #{user.id}, service ID: #{service.id}\n  year: 2010, week: 1, \n  errors: full_messages\n</p>\n\n"
  end
  
  it "should send email to administrator about number of successfully generated reports" do
    @expected.subject = "[retaste.me] [REPORT] [SUCCESS] - #{Date.today.to_s}"
    @expected.body    = read_fixture('broken_reports')
    @expected.from    = 'no-reply@retaste.me'
    @expected.to      = 'ladislav.martincik@gmail.com'
    
    response = NotifierMailer.create_successfully_generated_reports(2)
    response.body.should == "<h1>Notification from retaste.me:</h1>\n\nSuccessfully generated: 2\n"
  end

  private

    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/mailers/notifier_mailer/#{action}")
    end
  
end
