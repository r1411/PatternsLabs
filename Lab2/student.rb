# frozen_string_literal: true

require 'json'
require_relative 'student_base'

class Student < StudentBase
  # Конструктор из JSON строки
  def self.from_json_str(str)
    params = JSON.parse(str)
    raise ArgumentError, 'Fields required: fist_name, last_name, father_name' unless params.key?('first_name') && params.key?('last_name') && params.key?('father_name')

    first_name = params.delete('first_name')
    last_name = params.delete('last_name')
    father_name = params.delete('father_name')

    Student.new(first_name, last_name, father_name, params.transform_keys(&:to_sym))
  end

  # Делаем публичными геттеры и сеттеры базового класса
  public :phone, :telegram, :email, 'id=', 'phone=', 'telegram=', 'email=', 'git='

  # Стандартные геттеры для полей
  attr_reader :last_name, :first_name, :father_name

  # Стандартный конструктор
  def initialize(last_name, first_name, father_name, options = {})
    self.last_name = last_name
    self.first_name = first_name
    self.father_name = father_name
    super(options)
  end

  # Сеттеры с валидацией перед присваиванием
  def last_name=(new_last_name)
    raise ArgumentError, "Invalid argument: last_name=#{new_last_name}" unless Student.valid_name?(new_last_name)

    @last_name = new_last_name
  end

  def first_name=(new_first_name)
    raise ArgumentError, "Invalid argument: first_name=#{new_first_name}" unless Student.valid_name?(new_first_name)

    @first_name = new_first_name
  end

  def father_name=(new_father_name)
    raise ArgumentError, "Invalid argument: father_name=#{new_father_name}" unless Student.valid_name?(new_father_name)

    @father_name = new_father_name
  end

  # Отдельный сеттер для массовой установки контактов
  def set_contacts(contacts)
    self.phone = contacts[:phone] if contacts.key?(:phone)
    self.telegram = contacts[:telegram] if contacts.key?(:telegram)
    self.email = contacts[:email] if contacts.key?(:email)
  end

  # Имя пользователя в формате Фамилия И. О.
  def last_name_and_initials
    "#{last_name} #{first_name[0]}. #{father_name[0]}."
  end

  # Краткая информация о пользователе
  def short_info
    info = {}
    info[:last_name_and_initials] = last_name_and_initials
    info[:contact] = short_contact
    info[:git] = git
    JSON.generate(info)
  end

  # Методы приведения объекта к строке
  def to_s
    result = "#{last_name} #{first_name} #{father_name}"
    %i[id phone telegram email git].each do |attr|
      attr_val = send(attr)
      result += ", #{attr}=#{attr_val}" unless attr_val.nil?
    end
    result
  end

  def to_json_str
    attrs = {}
    %i[last_name first_name father_name id phone telegram email git].each do |attr|
      attr_val = send(attr)
      attrs[attr] = attr_val unless attr_val.nil?
    end
    JSON.generate(attrs)
  end
end
