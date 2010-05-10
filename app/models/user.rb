require 'rpx_now/user_integration'

class User < ActiveRecord::Base
  include RPXNow::UserIntegration

  # Validations
  validates_presence_of :email, :on => :update
  validates_uniqueness_of :email, :allow_blank => true
  validates_presence_of :username

  # Relations
  has_one :delicious, :dependent => :destroy
  has_many :reports, :dependent => :destroy
  
end