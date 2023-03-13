# frozen_string_literal: true

require 'json'
require_relative 'student_base'

class Student < StudentBase
  # Делаем new предка публичным
  public_class_method :new

  def self.from_hash(hash)
    raise ArgumentError, 'Fields required: fist_name, last_name, father_name' unless hash.key?(:first_name) && hash.key?(:last_name) && hash.key?(:father_name)

    first_name = hash.delete(:first_name)
    last_name = hash.delete(:last_name)
    father_name = hash.delete(:father_name)

    Student.new(last_name, first_name, father_name, **hash)
  end

  # Конструктор из JSON строки
  def self.from_json_str(str)
    params = JSON.parse(str, { symbolize_names: true })
    from_hash(params)
  end

  # Делаем публичными геттеры и сеттеры базового класса
  public :phone, :telegram, :email, 'id=', 'phone=', 'telegram=', 'email=', 'git='

  # Стандартные геттеры для полей
  attr_reader :last_name, :first_name, :father_name

  # Стандартный конструктор
  def initialize(last_name, first_name, father_name, **options)
    self.last_name = last_name
    self.first_name = first_name
    self.father_name = father_name
    super(**options)
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
  def set_contacts(phone: nil, telegram: nil, email: nil)
    self.phone = phone if phone
    self.telegram = telegram if telegram
    self.email = email if email
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

  def to_hash
    attrs = {}
    %i[last_name first_name father_name id phone telegram email git].each do |attr|
      attr_val = send(attr)
      attrs[attr] = attr_val unless attr_val.nil?
    end
    attrs
  end

  def to_json_str
    JSON.generate(to_hash)
  end
end
