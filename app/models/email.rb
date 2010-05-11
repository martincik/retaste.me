class Email < ActiveRecord::Base
  before_destroy :save_history_email
  
  def save_history_email
    EmailHistory.create!(
      :from => self.from,
      :to => self.to,
      :last_send_attempt => self.last_send_attempt,
      :mail => self.mail,
      :created_at => self.created_on,
      :sent_at => Time.now
    )
    true
  end
end