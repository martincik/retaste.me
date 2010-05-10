class NotifierMailer < ActionMailer::ARMailer
  layout 'notifier_mailer'
  
  def broken_reports(reports, num_reports)
    subject "[retaste.me] [REPORT] [BROKEN] - #{Date.today.to_s}"
    from "no-reply@retaste.me"
    body :reports => reports, :num_reports => num_reports
    content_type "text/plain"
    charset 'utf-8'
  end
  
  def successfully_generated_reports(num_reports)
    subject "[retaste.me] [REPORT] [SUCCESS] - #{Date.today.to_s}"
    from "no-reply@retaste.me"
    body :num_reports => num_reports
    content_type "text/plain"
    charset 'utf-8'
  end
end