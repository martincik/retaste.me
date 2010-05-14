class ReportMailer < ActionMailer::Base
  layout 'report_mailer'
  
  def weekly_report(links, recipient, sent_at = Time.now)
    recipients recipient
    subject "retaste.me your Week report ##{Date.today.cweek.to_s}"
    from "no-reply@retaste.me"
    body :links => links
    content_type "text/html"
    charset 'utf-8'
    sent_on sent_at
  end
  
end