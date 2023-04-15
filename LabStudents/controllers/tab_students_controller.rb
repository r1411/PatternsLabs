# frozen_string_literal: true

require './LabStudents/views/main_window'
require './LabStudents/repositories/student_repository'
require './LabStudents/repositories/adapters/db_source_adapter'
require './LabStudents/repositories/containers/data_list_student_short'
require 'win32api'

class TabStudentsController
  def initialize(view)
    @view = view
    @data_list = DataListStudentShort.new([])
    @data_list.add_listener(@view)
  end

  def on_view_created
    begin
      @student_rep = StudentRepository.new(DBSourceAdapter.new)
    rescue Mysql2::Error::ConnectionError
      on_db_conn_error
    end
  end

  def show_view
    @view.create.show
  end

  def refresh_data(page, per_page)
    begin
      @data_list = @student_rep.paginated_short_students(page, per_page, @data_list)
      @view.update_student_count(@student_rep.student_count)
    rescue
      on_db_conn_error
    end
  end

  def on_db_conn_error
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    # TODO: Возможность переключения на JSON помимо exit
    exit(false)
  end
end
