class NotifierMailer < ActionMailer::ARMailer
  layout 'notifier_mailer'
  
  def broken_reports(reports, num_reports, sent_at = Time.now)
    subject "[retaste.me] [REPORT] [BROKEN] - #{Date.today.to_s}"
    from "no-reply@retaste.me"
    recipients "ladislav.martincik@gmail.com"
    body :reports => reports, :num_reports => num_reports
    content_type "text/plain"
    charset 'utf-8'
    sent_on sent_at
  end
  
  def successfully_generated_reports(num_reports, sent_at = Time.now)
    subject "[retaste.me] [REPORT] [SUCCESS] - #{Date.today.to_s}"
    from "no-reply@retaste.me"
    recipients "ladislav.martincik@gmail.com"
    body :num_reports => num_reports
    content_type "text/plain"
    charset 'utf-8'
    sent_on sent_at
  end
end