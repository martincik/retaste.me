class Delicious < Service
  validates_presence_of :login, :message => "can't be blank"
  validates_presence_of :password, :message => "can't be blank"
  
  validate :validate_account
  def validate_account
    d = WWW::Delicious.new(login, password, :user_agent => 'retaste.me/1.0')
    unless d.valid_account?
      errors.add(:base, "Login or password invalid! Please, try again.")
    end
  end
  
  def links_for_week(week_number = Date.today.cweek)
    week_start, week_end = week_start_end(week_number)
    d = WWW::Delicious.new(login, password, :user_agent => 'retaste.me/1.0')
    d.posts_all(:fromdt => week_start, :todt => week_end)
  end
  
  private
  
    def week_start_end(week_number)
      year = Time.now.year
      week_start = Date.commercial( year, week_number, 1 )
      week_end = Date.commercial( year, week_number, 7 )
      return week_start.to_time, week_end.to_time
    end
  
end