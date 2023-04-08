# frozen_string_literal: true

require './LabStudents/views/main_window'
require './LabStudents/repositories/student_repository'
require './LabStudents/repositories/adapters/db_source_adapter'
require './LabStudents/repositories/containers/data_list_student_short'
require './LabStudents/events/event_manager'
require './LabStudents/events/impl/event_update_students_count'
require 'win32api'

class TabStudentsController
  def initialize(view)
    begin
      @student_rep = StudentRepository.new(DBSourceAdapter.new)
    rescue Mysql2::Error::ConnectionError
      api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
      api.call(0, "No connection to DB", "Error", 0)
      # TODO: Возможность переключения на JSON помимо exit
      exit(false)
      return
    end
    @view = view
    @data_list = DataListStudentShort.new([])
  end

  def show_view
    @view.create.show
  end

  def refresh_data(page, per_page)
    @data_list = @student_rep.paginated_short_students(page, per_page, @data_list)
    EventManager.notify(EventUpdateStudentsCount.new(@student_rep.student_count))
  end
end
