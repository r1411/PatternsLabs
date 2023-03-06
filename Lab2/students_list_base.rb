# frozen_string_literal: true

class StudentsListBase
  private_class_method :new

  def initialize
    self.students = []
    self.seq_id = 1
  end

  def load_from_file(file_path)
    hash_list = str_to_hash_list(File.read(file_path))
    self.students = hash_list.map { |h| Student.from_hash(h) }
    update_seq_id
  end

  def save_to_file(file_path)
    hash_list = students.map(&:to_hash)
    File.write(file_path, hash_list_to_str(hash_list))
  end

  def student_by_id(student_id)
    students.detect { |s| s.id == student_id }
  end

  # Получить page по счету count элементов (страница начинается с 1)
  def paginated_short_students(page, count, existing_data_list: nil)
    offset = (page - 1) * count
    slice = students[offset, count].map { |s| StudentShort.from_student(s) }

    return DataListStudentShort.new(slice) if existing_data_list.nil?

    existing_data_list.append(slice)
  end

  def sorted
    students.sort_by(&:last_name_and_initials)
  end

  def add_student(student)
    student.id = seq_id
    students << student
    self.seq_id += 1
  end

  def replace_student(student_id, student)
    idx = student.find_index { |s| s.id == student_id }
    students[idx] = student
  end

  def remove_student(student_id)
    students.reject! { |s| s.id == student_id }
  end

  def student_count
    students.count
  end

  protected

  # Методы работы с файлами. Переопределить в потомках.
  def str_to_hash_list(str); end

  def hash_list_to_str(hash_list); end

  private

  # Метод для актуализации seq_id
  def update_seq_id
    self.seq_id = students.max_by(&:id).id + 1
  end

  attr_accessor :students, :seq_id
end
