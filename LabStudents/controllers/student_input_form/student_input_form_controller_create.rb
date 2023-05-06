# frozen_string_literal: true

require './LabStudents/util/logger_holder'
require 'win32api'

##
# Контроллер для модального окна создания студента

class StudentInputFormControllerCreate
  def initialize(parent_controller)
    @parent_controller = parent_controller
    LoggerHolder.instance.debug('StudentInputFormControllerCreate: initialized')
  end

  def set_view(view)
    @view = view
    LoggerHolder.instance.debug('StudentInputFormControllerCreate: view set')
  end

  ##
  # Вызывается из view после ее создания

  def on_view_created
    begin
      @student_rep = StudentRepository.new(DBSourceAdapter.new)
    rescue Mysql2::Error::ConnectionError => e
      on_db_conn_error(e)
    end
  end

  ##
  # Обработать данные из полей и добавить студента

  def process_fields(fields)
    begin
      last_name = fields.delete(:last_name)
      first_name = fields.delete(:first_name)
      father_name = fields.delete(:father_name)

      return if last_name.nil? || first_name.nil? || father_name.nil?

      student = Student.new(last_name, first_name, father_name, **fields)

      LoggerHolder.instance.debug('StudentInputFormControllerCreate: adding student to DB')

      @student_rep.add_student(student)

      @view.close
    rescue ArgumentError => e
      LoggerHolder.instance.debug("StudentInputFormControllerCreate: wrong fields: #{e.message}")
      api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
      api.call(0, e.message, 'Error', 0)
    end
  end

  private

  ##
  # Обработчик ошибки подключения к БД

  def on_db_conn_error(error)
    LoggerHolder.instance.debug('StudentInputFormControllerCreate: DB connection error:')
    LoggerHolder.instance.error(error.message)
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    @view.close
  end
end
