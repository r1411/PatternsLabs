# frozen_string_literal: true

class FileSourceAdapter
  def initialize(data_transformer, file_path)
    @file_path = file_path
    @file_source = FileDataSource.new(data_transformer)
    @file_source.load_from_file(file_path)
  end

  def student_by_id(student_id)
    @file_source.student_by_id(student_id)
  end

  def paginated_short_students(page, count, existing_data_list = nil)
    @file_source.paginated_short_students(page, count, existing_data_list)
  end

  def add_student(student)
    added_id = @file_source.add_student(student)
    @file_source.save_to_file(@file_path)
    added_id
  end

  def replace_student(student_id, student)
    @file_source.replace_student(student_id, student)
    @file_source.save_to_file(@file_path)
  end

  def remove_student(student_id)
    @file_source.remove_student(student_id)
    @file_source.save_to_file(@file_path)
  end

  def student_count
    @file_source.student_count
  end
end
