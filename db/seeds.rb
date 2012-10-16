# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
MessageType.find_or_create_by_name('Emergency')
MessageType.find_or_create_by_name('Outreach')
MessageType.find_or_create_by_name('Attendance')

ContactMethodType.find_or_create_by_name('Phone')
ContactMethodType.find_or_create_by_name('SMS')
ContactMethodType.find_or_create_by_name('Email')

RecipientType.find_or_create_by_name('Student')
RecipientType.find_or_create_by_name('Parent')
RecipientType.find_or_create_by_name('Staff')
RecipientType.find_or_create_by_name('PowerSchool Demographics')

