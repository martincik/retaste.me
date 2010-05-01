class Delicious < Service
  validates_presence_of :login, :message => "can't be blank"
  validates_presence_of :password, :message => "can't be blank"
end