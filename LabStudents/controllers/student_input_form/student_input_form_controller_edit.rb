# frozen_string_literal: true

require './LabStudents/util/logger_holder'
require 'win32api'

class StudentInputFormControllerEdit
  def initialize(parent_controller, existing_student_id)
    @parent_controller = parent_controller
    @existing_student_id = existing_student_id
    LoggerHolder.instance.debug('StudentInputFormControllerEdit: initialized')
  end

  def set_view(view)
    @view = view
    LoggerHolder.instance.debug('StudentInputFormControllerEdit: view set')
  end

  def on_view_created
    begin
      @student_rep = StudentRepository.new(DBSourceAdapter.new)
    rescue Mysql2::Error::ConnectionError => e
      on_db_conn_error(e)
    end
    @existing_student = @student_rep.student_by_id(@existing_student_id)
    @view.make_readonly(:git, :telegram, :email, :phone)
    populate_fields(@existing_student)
  end

  def populate_fields(student)
    @view.set_value(:last_name, student.last_name)
    @view.set_value(:first_name, student.first_name)
    @view.set_value(:father_name, student.father_name)
    @view.set_value(:git, student.git)
    @view.set_value(:telegram, student.telegram)
    @view.set_value(:email, student.email)
    @view.set_value(:phone, student.phone)
  end

  def process_fields(fields)
    begin
      new_student = Student.from_hash(fields)

      LoggerHolder.instance.debug('StudentInputFormControllerEdit: replacing student in DB')

      @student_rep.replace_student(@existing_student_id, new_student)

      @view.close
    rescue ArgumentError => e
      LoggerHolder.instance.debug("StudentInputFormControllerEdit: wrong fields: #{e.message}")
      api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
      api.call(0, e.message, 'Error', 0)
    end
  end

  private

  def on_db_conn_error(error)
    LoggerHolder.instance.debug('StudentInputFormControllerEdit: DB connection error:')
    LoggerHolder.instance.error(error.message)
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    @view.close
  end
end
