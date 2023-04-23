# frozen_string_literal: true

require 'win32api'

class StudentInputFormControllerCreate
  def initialize(parent_controller)
    @parent_controller = parent_controller
  end

  def set_view(view)
    @view = view
  end

  def on_view_created
    begin
      @student_rep = StudentRepository.new(DBSourceAdapter.new)
    rescue Mysql2::Error::ConnectionError
      on_db_conn_error
    end
  end

  def process_fields(fields)
    begin
      last_name = fields.delete(:last_name)
      first_name = fields.delete(:first_name)
      father_name = fields.delete(:father_name)

      return if last_name.nil? || first_name.nil? || father_name.nil?

      student = Student.new(last_name, first_name, father_name, **fields)

      @student_rep.add_student(student)

      @view.close
    rescue ArgumentError => e
      api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
      api.call(0, e.message, 'Error', 0)
    end
  end

  private

  def on_db_conn_error
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    @view.close
  end
end
