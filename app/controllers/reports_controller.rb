class ReportsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  def index
    redirect_to :action => 'show' if RAILS_ENV == 'production'
    
    require 'ostruct'
    @links = [
      OpenStruct.new(:url => "http://my.safaribooksonline.com/9780132107549#tabfeedbacks",
        :tags => ["book", "tobuy", "dsl", "language"],
        :time => 'May 12, 16:28',
        :title => "Safari Books Online: Domain Specific Languages"
      ),
      OpenStruct.new(:url => "http://my.safaribooksonline.com/9780132107549#tabfeedbacks",
        :tags => ["book", "tobuy", "dsl", "language"],
        :time => 'May 12, 16:28',
        :title => "Safari Books Online: Domain Specific Languages"
      )
    ]
    
    render :template => 'report_mailer/weekly_report', :layout => 'report_mailer'
  end
  
  def show
    report = Report.first(:conditions => { :year => params[:year].to_i, :week => params[:week].to_i })
    raise ActiveRecord::RecordNotFound if report.nil?
    
    respond_to do |format|
      format.html { render :text => report.from_html }
    end
  end
  
  private
    
    def record_not_found
      respond_to do |format|
        format.html {
          flash[:error] = "Sorry no such report exists!"
          redirect_to root_path
        }
      end
    end
  
end
