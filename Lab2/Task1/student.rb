# frozen_string_literal: true

class Student
  attr_accessor :last_name, :first_name, :father_name, :id, :phone, :telegram, :email, :git

  def initialize(last_name, first_name, father_name, options = {})
    @last_name = last_name
    @first_name = first_name
    @father_name = father_name
    @id = options[:id]
    @phone = options[:phone]
    @telegram = options[:telegram]
    @email = options[:email]
    @git = options[:git]
  end

  def to_s
    result = "#{@last_name} #{@first_name} #{@father_name}"
    %i[id phone telegram email git].each do |attr|
      attr_val = send(attr)
      result += ", #{attr}=#{attr_val}" unless attr_val.nil?
    end
    result
  end
end