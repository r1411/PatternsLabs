# frozen_string_literal: true

class StudentShort < StudentBase
  private

  attr_writer :last_name_and_initials, :contact

  public

  attr_reader :last_name_and_initials, :contact, :id, :git

  def self.from_student(student)
    raise ArgumentError, 'Student ID is required' if student.id.nil?

    StudentShort.new(student.id, student.short_info)
  end

  def initialize(id, info_str)
    params = JSON.parse(info_str).transform_keys(&:to_sym)
    raise ArgumentError, 'Fields required: last_name_and_initials' if !params.key?(:last_name_and_initials) || params[:last_name_and_initials].nil?

    self.id = id
    self.last_name_and_initials = params[:last_name_and_initials]
    self.contact = params[:contact].transform_keys(&:to_sym)
    self.git = params[:git]

    options = {}
    options[:id] = id
    options[:git] = git
    options[contact[:type].to_sym] = contact[:value]
    super(options)
  end

  def to_s
    result = last_name_and_initials
    %i[id contact git].each do |attr|
      attr_val = send(attr)
      result += ", #{attr}=#{attr_val}" unless attr_val.nil?
    end
    result
  end
end