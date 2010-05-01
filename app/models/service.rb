class Service < ActiveRecord::Base
  validates_presence_of :user_id, :message => "can't be blank"
  belongs_to :user
  
  before_save :do_not_allow_save_abstract_class
  def do_not_allow_save_abstract_class
    return false if instance_of? Service
  end
end
