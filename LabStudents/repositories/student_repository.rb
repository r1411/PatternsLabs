# frozen_string_literal: true

class StudentRepository
  def initialize(data_source_adapter)
    @data_source_adapter = data_source_adapter
  end

  def student_by_id(student_id)
    @data_source_adapter.student_by_id(student_id)
  end

  # Получить page по счету count элементов (страница начинается с 1)
  def paginated_short_students(page, count, existing_data_list = nil)
    @data_source_adapter.paginated_short_students(page, count, existing_data_list)
  end

  def add_student(student)
    @data_source_adapter.add_student(student)
  end

  def replace_student(student_id, student)
    @data_source_adapter.replace_student(student_id, student)
  end

  def remove_student(student_id)
    @data_source_adapter.remove_student(student_id)
  end

  def student_count
    @data_source_adapter.student_count
  end
end
