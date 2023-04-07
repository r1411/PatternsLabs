# frozen_string_literal: true

require './LabStudents/views/main_window'
require './LabStudents/repositories/student_repository'
require './LabStudents/repositories/adapters/db_source_adapter'
require './LabStudents/repositories/containers/data_list_student_short'

class TabStudentsController
  def initialize(view)
    @student_rep = StudentRepository.new(DBSourceAdapter.new)
    @view = view
    @data_list = DataListStudentShort.new([])
  end

  def show_view
    @view.create.show
  end

  def refresh_data(page, per_page)
    @data_list = @student_rep.paginated_short_students(page, per_page, @data_list)
  end
end
