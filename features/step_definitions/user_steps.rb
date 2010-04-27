Given /^the following users:$/ do |users|
  User.create!(users.hashes)
end