# frozen_string_literal: true

require './LabStudents/views/main_window'
require './LabStudents/repositories/student_repository'
require './LabStudents/repositories/adapters/db_source_adapter'
require './LabStudents/repositories/containers/data_list_student_short'
require './LabStudents/views/student_input_form'
require './LabStudents/controllers/student_input_form/student_input_form_controller_create'
require './LabStudents/controllers/student_input_form/student_input_form_controller_edit'
require './LabStudents/util/logger_holder'
require 'win32api'

class TabStudentsController
  def initialize(view)
    LoggerHolder.instance.debug('TabStudentsController: init start')
    @view = view
    @data_list = DataListStudentShort.new([])
    @data_list.add_listener(@view)
    LoggerHolder.instance.debug('TabStudentsController: init done')
  end

  def on_view_created
    begin
      @student_rep = StudentRepository.new(DBSourceAdapter.new)
      LoggerHolder.instance.debug('TabStudentsController: created student repository')
    rescue Mysql2::Error::ConnectionError => e
      on_db_conn_error(e)
    end
  end

  def show_modal_add
    LoggerHolder.instance.debug('TabStudentsController: showing modal (add)')
    controller = StudentInputFormControllerCreate.new(self)
    view = StudentInputForm.new(controller)
    controller.set_view(view)
    view.create.show
  end

  def show_modal_edit(current_page, per_page, selected_row)
    LoggerHolder.instance.debug('TabStudentsController: showing modal (edit)')
    student_num = (current_page - 1) * per_page + selected_row
    @data_list.select_element(student_num)
    student_id = @data_list.selected_id
    controller = StudentInputFormControllerEdit.new(self, student_id)
    view = StudentInputForm.new(controller)
    controller.set_view(view)
    view.create.show
  end

  def delete_selected(current_page, per_page, selected_row)
    begin
      LoggerHolder.instance.debug('TabStudentsController: deleting selected student')
      student_num = (current_page - 1) * per_page + selected_row
      @data_list.select_element(student_num)
      student_id = @data_list.selected_id
      @student_rep.remove_student(student_id)
    rescue Mysql2::Error::ConnectionError => e
      on_db_conn_error(e)
    end
  end

  def refresh_data(page, per_page)
    begin
      LoggerHolder.instance.debug('TabStudentsController: refreshing data...')
      @data_list = @student_rep.paginated_short_students(page, per_page, @data_list)
      @view.update_student_count(@student_rep.student_count)
    rescue Mysql2::Error::ConnectionError => e
      on_db_conn_error(e)
    end
  end

  private

  def on_db_conn_error(error)
    LoggerHolder.instance.error('TabStudentsController: DB connection error:')
    LoggerHolder.instance.error(error.message)
    api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
    api.call(0, "No connection to DB", "Error", 0)
    # TODO: Возможность переключения на JSON помимо exit
    exit(false)
  end
end
