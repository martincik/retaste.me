Factory.sequence :email do |n|
  "person#{n}@example.com"
end

Factory.define :user do |u|
  u.username 'ladislav.martincik'
  u.name 'ladislav.martincik'
  u.email { Factory.next(:email) }
  u.identifier 'https://www.google.com/accounts/o8/id?id=AItOawkp2mIlMY0AAoTybC13TUnV3fPhtzdHTTM'
end