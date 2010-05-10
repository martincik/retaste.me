class Report < ActiveRecord::Base
  
  # Relations
  belongs_to :user
  belongs_to :service
  
  # Hooks
  before_save :to_html
  
  def to_html
    
  end
  
  def from_html
    raise ActiveRecord::RecordNotFound unless File.exists?(report_file_path)
    File.read(report_file_path) 
  end
  
  def self.generate_reports_for_current_week
    broken_reports = []
    num_reports = 0
    
    User.all.each do |user|
      report = user.delicious.generate_current_week_report
      if report.new_record? || !report.errors.empty?
        broken_reports << report
        Rails.logger.error "Couldn't save report for user ID: #{user.id} => #{report.errors}"
      else
        num_reports += 1
        Rails.logger.info "Generated report for user ID: #{user.id}, year: #{report.year}, week: #{report.week}"
      end
    end
    
    if broken_reports.empty?
      NotifierMailer.deliver_successfully_generated_reports(num_reports)
    else
      NotifierMailer.deliver_broken_reports(broken_reports, num_reports)
    end
    
    broken_reports
  end
  
  def composed_id
    "#{user.id}_#{service.id}_#{week}_#{year}"
  end
  
  private
    
    def report_file_path
      File.join(RAILS_ROOT, 'data', 'reports', "#{composed_id}.html")
    end
  
end
