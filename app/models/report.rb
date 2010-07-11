class Report < ActiveRecord::Base
  
  # Relations
  belongs_to :user
  belongs_to :service
  
  def to_html
    email = ReportMailer.deliver_weekly_report(service.links_for_week, user, user.email)
    File.open(report_file_path, 'w') { |f| f.write(email.body) }
  end
  
  def from_html
    raise ActiveRecord::RecordNotFound unless File.exists?(report_file_path)
    File.read(report_file_path) 
  end
  
  def self.generate_reports_for_current_week(debug = false)
    broken_reports = []
    exceptions = []
    num_reports = 0
    
    Delicious.all.each do |delicious|
      Report.transaction do
        begin
          report = delicious.generate_current_week_report
          
          cont = false; num_of_tries = 0
          until cont do
            begin
              report.to_html
              cont = true
            rescue WWW::Delicious::HTTPError => e
              exceptions << e
              num_of_tries += 1
              cont = true if num_of_tries > 3
              Rails.logger.error e.to_s
              Rails.logger.error "Waiting 10s to get back to download data."
              sleep 10 # Let's see if that helps!
            end
          end

          if report.save 
            num_reports += 1
            Rails.logger.info "Generated report for user ID: #{delicious.user.id}, year: #{report.year}, week: #{report.week}"            
          else
            broken_reports << report
            Rails.logger.error "Couldn't save report for user ID: #{delicious.user.id}, Errors: #{report.errors}"
          end
          
          Rails.logger.info "Sleeping for 2 seconds..."
          sleep 2
        rescue Exception => e
          exceptions << e
          Rails.logger.error "Couldn't save report for user ID: #{delicious.user.id}, Exception: #{e}"
          raise ActiveRecord::Rollback
        end
      end
    end
    
    return if debug
    
    if num_reports > 0
      NotifierMailer.deliver_successfully_generated_reports(num_reports)
    end
    
    unless broken_reports.empty?
      NotifierMailer.deliver_broken_reports(broken_reports, num_reports)
    end

    unless exceptions.empty?
      NotifierMailer.deliver_exceptions(exceptions)
    end

    broken_reports.empty? ? exceptions : broken_reports
  end
  
  def composed_id
    "#{user.id}_#{service.id}_#{week}_#{year}"
  end
  
  private
    
    def report_file_path
      File.join(RAILS_ROOT, 'data', 'reports', "#{composed_id}.html")
    end
  
end
