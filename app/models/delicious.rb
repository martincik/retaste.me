class Delicious < Service
  validates_presence_of :login, :message => "can't be blank"
  validates_presence_of :password, :message => "can't be blank"
  
  validate :validate_account
  def validate_account
    d = WWW::Delicious.new(login, password)
    unless d.valid_account?
      errors.add(:base, "Login or password invalid! Please, try again.")
    end
  end
  
end