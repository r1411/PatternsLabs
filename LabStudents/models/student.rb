# frozen_string_literal: true

require 'json'
require_relative 'student_base'

##
# Модель студента

class Student < StudentBase
  public_class_method :new

  ##
  # Конструктор из Hash. Ключи являются символами
  def self.from_hash(hash)
    hash = hash.dup
    raise ArgumentError, 'Fields required: fist_name, last_name, father_name' unless hash.key?(:first_name) && hash.key?(:last_name) && hash.key?(:father_name)

    first_name = hash.delete(:first_name)
    last_name = hash.delete(:last_name)
    father_name = hash.delete(:father_name)

    Student.new(last_name, first_name, father_name, **hash)
  end

  ##
  # Конструктор из JSON строки

  def self.from_json_str(str)
    params = JSON.parse(str, { symbolize_names: true })
    from_hash(params)
  end

  public :phone, :telegram, :email, 'id=', 'phone=', 'telegram=', 'email=', 'git='

  attr_reader :last_name, :first_name, :father_name

  ##
  # Стандартный конструктор. Принимает: Фамилия, Имя, Отчество, а также именованные параметры для предка
  def initialize(last_name, first_name, father_name, **options)
    self.last_name = last_name
    self.first_name = first_name
    self.father_name = father_name
    super(**options)
  end

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

  ##
  # Сеттер для массовой установки контактов

  def set_contacts(phone: nil, telegram: nil, email: nil)
    self.phone = phone if phone
    self.telegram = telegram if telegram
    self.email = email if email
  end

  ##
  # Вернуть фамилию и инициалы в виде строки "Фамилия И. О."

  def last_name_and_initials
    "#{last_name} #{first_name[0]}. #{father_name[0]}."
  end

  ##
  # Краткая информация о пользователе в виде JSON строки.
  # Поля:
  # last_name_and_initials - Фамилия и инициалы в виде "Фамилия И. О."
  # contact - Приоритетный доступный контакт в виде хеша (StudentBase#short_contact)
  # git - Имя пользователя на гите

  def short_info
    info = {}
    info[:last_name_and_initials] = last_name_and_initials
    info[:contact] = short_contact
    info[:git] = git
    JSON.generate(info)
  end

  ##
  # Преобразование студента в строку

  def to_s
    result = "#{last_name} #{first_name} #{father_name}"
    %i[id phone telegram email git].each do |attr|
      attr_val = send(attr)
      result += ", #{attr}=#{attr_val}" unless attr_val.nil?
    end
    result
  end

  ##
  # Преобразование студента в хеш. Поля являются ключами

  def to_hash
    attrs = {}
    %i[last_name first_name father_name id phone telegram email git].each do |attr|
      attr_val = send(attr)
      attrs[attr] = attr_val unless attr_val.nil?
    end
    attrs
  end

  ##
  # Преобразование студента в JSON строку.

  def to_json_str
    JSON.generate(to_hash)
  end
end
