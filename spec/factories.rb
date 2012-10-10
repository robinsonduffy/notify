Factory.define :user do |user|
  user.username "UserName"
  user.password "foobar"
  user.name "Test User"
end

Factory.define :recipient do |recipient|
  recipient.external_id "12345"
  recipient.first_name "Test"
  recipient.last_name "Student"
  recipient.association :recipient_type
end

Factory.define :contact_method do |contact_method|
  contact_method.contact_method_type "phone"
  contact_method.delivery_route "19074554225"
  contact_method.association :recipient
end

Factory.define :delivery_option do |delivery_option|
  delivery_option.option_scope 'self'
  delivery_option.options ['emergency']
  delivery_option.scope_id 1
  delivery_option.association :contact_method
end

Factory.define :school do |school|
  school.name "Test School"
end

Factory.define :group do |group|
  group.name "Test Group"
  group.association :user
end

Factory.define :recipient_type do |recipient_type|
  recipient_type.name "Student"
end