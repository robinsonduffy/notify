include ActionView::Helpers::NumberHelper

def email_regex
  #many thanks to RoR Tutorial
  /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
end

String.class_eval do
  def computerize_phone_number
    computerized_phone_number = self.gsub(/\D/,'')
    computerized_phone_number = "1#{computerized_phone_number}"
    return computerized_phone_number if computerized_phone_number.length == 11
    return nil
  end

  def humanize_phone_number
    humanized_phone_number = "#{self.gsub(/\D/,'')}"
    humanized_phone_number.slice!(0)
    return false unless humanized_phone_number.length == 10
    return number_to_phone(humanized_phone_number, :area_code => true)
  end
end