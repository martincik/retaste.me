class ReportsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
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
