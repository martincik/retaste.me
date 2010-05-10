Factory.define :report do |u|
  u.week Date.today.cweek
  u.year Date.today.year
  u.association :service, :factory => :delicious
end