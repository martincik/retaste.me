class Service < ActiveRecord::Base

  # Validations
  validates_presence_of :user_id, :message => "can't be blank"

  # Relations
  belongs_to :user
  has_many :reports, :dependent => :destroy
  
  before_save :do_not_allow_save_abstract_class
  def do_not_allow_save_abstract_class
    return false if instance_of? Service
  end
  
  def generate_current_week_report
    report = Report.create(:user => user, 
      :service => self, 
      :week => Date.today.cweek,
      :year => Date.today.year
    )
    self.reports << report
    report
  end

end
