require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe ReportMailer do
  
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = 'utf-8'
  
  before(:each) do
    Delicious.any_instance.stubs(:validate_account).returns(true)
  end
  
  it "should send email to user with weekly report" do
    user = Factory(:user)
    service = Factory(:delicious, :user => user)

    # Example of Delicious Post response structure:
    # #<WWW::Delicious::Post:0x108107968 @uid="39492dcb41e038881e927c8504ae513f", 
    #   @others=0, @shared=nil, @notes="", 
    #   @url=#<URI::HTTP:0x108107440 URL:http://my.safaribooksonline.com/9780132107549#tabfeedbacks>, 
    #   @tags=["book", "tobuy", "dsl", "language"], 
    #   @time=Wed May 12 16:28:22 UTC 2010, 
    #   @title="Safari Books Online: Domain Specific Languages">
    links = [
      OpenStruct.new(:url => "http://my.safaribooksonline.com/9780132107549#tabfeedbacks",
        :tags => ["book", "tobuy", "dsl", "language"],
        :time => 'May 12, 16:28',
        :title => "Safari Books Online: Domain Specific Languages"
      )
    ]
        
    response = ReportMailer.create_weekly_report(links || [], user, user.email)
    response.encoded.include?('http://').should be_true
    response.encoded.include?('book').should be_true
    response.encoded.include?('Ladislav Martincik').should be_true
    response.encoded.include?('12 May at 04:28PM').should be_true
    response.encoded.include?('Safari Books Online: Domain Specific Languages').should be_true
  end
  
  private

    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/mailers/report_mailer/#{action}")
    end
  
end
