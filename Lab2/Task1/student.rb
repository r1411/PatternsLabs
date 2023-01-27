# frozen_string_literal: true

class Student
  attr_accessor :last_name, :first_name, :father_name, :id, :phone, :telegram, :email, :git

  def initialize(last_name, first_name, father_name, id: nil, phone: nil, telegram: nil, email: nil, git: nil)
    @last_name = last_name
    @first_name = first_name
    @father_name = father_name
    @id = id
    @phone = phone
    @telegram = telegram
    @email = email
    @git = git
  end
end
