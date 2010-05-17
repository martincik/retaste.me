class Report < ActiveRecord::Base
  
  # Relations
  belongs_to :user
  belongs_to :service
  
  def to_html
    email = ReportMailer.deliver_weekly_report(service.links_for_week, user.email)
    File.open(report_file_path, 'w') { |f| f.write(email.body) }
  end
  
  def from_html
    raise ActiveRecord::RecordNotFound unless File.exists?(report_file_path)
    File.read(report_file_path) 
  end
  
  def self.generate_reports_for_current_week
    broken_reports = []
    num_reports = 0
    
    User.all.each do |user|
      Report.transaction do
        begin
          next if user.delicious.nil?
          report = user.delicious.generate_current_week_report
          report.to_html
          if report.save
            num_reports += 1
            Rails.logger.info "Generated report for user ID: #{user.id}, year: #{report.year}, week: #{report.week}"            
          else
            broken_reports << report
            Rails.logger.error "Couldn't save report for user ID: #{user.id}, Errors: #{report.errors}"
          end
        rescue Exception => e
          broken_reports << report
          Rails.logger.error "Couldn't save report for user ID: #{user.id}, Exception: #{e}"
          raise ActiveRecord::Rollback
        end
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
