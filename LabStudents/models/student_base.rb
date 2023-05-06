# frozen_string_literal: true

##
# Абстрактный класс с базовым описанием студента

class StudentBase
  private_class_method :new

  ##
  # Валидация имени (также применимо к фамилии и отчеству)

  def self.valid_name?(name)
    name.match(/(^[А-Я][а-я]+$)|(^[A-Z][a-z]+$)/)
  end

  ##
  # Валидация номера телефона

  def self.valid_phone?(phone)
    phone.match(/^\+?[78] ?[(-]?\d{3} ?[)-]?[ -]?\d{3}[ -]?\d{2}[ -]?\d{2}$/)
  end

  ##
  # Валидация имени профиля пользователя

  def self.valid_profile_name?(profile_name)
    profile_name.match(/^[a-zA-Z0-9_.]+$/)
  end

  ##
  # Валидация email

  def self.valid_email?(email)
    email.match(/^(?:[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])$/)
  end

  protected

  attr_writer :id
  attr_reader :phone, :telegram, :email

  public

  attr_reader :id, :git

  ##
  # Стандартный конструктор. Принимает именованные параметры:
  # id - Id студента
  # phone - Телефон
  # telegram - Ник в телеграме
  # email - Электронная почта
  # git - Ник на гите

  def initialize(id: nil, phone: nil, telegram: nil, email: nil, git: nil)
    self.id = id
    self.phone = phone
    self.telegram = telegram
    self.email = email
    self.git = git
  end

  ##
  # Возвращает первый доступный контакт пользователя в виде хеша.
  # Пример: {type: :telegram, value: 'xoxolovelylove'}

  def short_contact
    contact = {}
    %i[telegram email phone].each do |attr|
      attr_val = send(attr)
      next if attr_val.nil?

      contact[:type] = attr
      contact[:value] = attr_val
      return contact
    end

    nil
  end

  protected

  def phone=(new_phone)
    raise ArgumentError, "Invalid argument: phone=#{new_phone}" unless new_phone.nil? || StudentBase.valid_phone?(new_phone)

    @phone = new_phone
  end

  def telegram=(new_telegram)
    raise ArgumentError, "Invalid argument: telegram=#{new_telegram}" unless new_telegram.nil? || StudentBase.valid_profile_name?(new_telegram)

    @telegram = new_telegram
  end

  def git=(new_git)
    raise ArgumentError, "Invalid argument: git=#{new_git}" unless new_git.nil? || StudentBase.valid_profile_name?(new_git)

    @git = new_git
  end

  def email=(new_email)
    raise ArgumentError, "Invalid argument: email=#{new_email}" unless new_email.nil? || StudentBase.valid_email?(new_email)

    @email = new_email
  end

  public

  ##
  # Возвращает true, если у студента есть хотя бы один из контактов

  def has_contacts?
    !phone.nil? || !telegram.nil? || !email.nil?
  end

  ##
  # Возвращает true, если у студента есть гит

  def has_git?
    !git.nil?
  end

  ##
  # Возвращает true, если у студента есть хотя бы один из контактов и гит

  def valid?
    has_contacts? && has_git?
  end
end
