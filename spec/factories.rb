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
  contact_method.delivery_route "19074554225"
  contact_method.association :recipient
  contact_method.association :contact_method_type
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

Factory.define :list do |list|
  list.name "Test List"
  list.description "Test List Description"
  list.association :user
  list.association :school
end

Factory.define :recipient_type do |recipient_type|
  recipient_type.name "Student"
end

Factory.define :contact_method_type do |contact_method_type|
  contact_method_type.name "SMS"
end

Factory.define :message_type do |message_type|
  message_type.name "emergency"
end

Factory.define :message do |message|
  message.name "Test Message"
  message.association :user
end

Factory.define :from_method do |from_method|
  from_method.from_method_type "email"
  from_method.from_method "test@example.com"
end

Factory.define :delivery_method do |delivery_method|
  delivery_method.association :message
  delivery_method.association :from_method
  delivery_method.association :contact_method_type
end