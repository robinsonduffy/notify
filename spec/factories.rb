Factory.define :user do |user|
  user.username "UserName"
  user.password "foobar"
  user.name "Test User"
end

Factory.define :recipient do |recipient|
  recipient.external_id "12345"
  recipient.recipient_type "student"
  recipient.first_name "Test"
  recipient.last_name "Student"
end

Factory.define :contact_method do |contact_method|
  contact_method.contact_method_type "phone"
  contact_method.delivery_route "19074554225"
  contact_method.association :recipient
end