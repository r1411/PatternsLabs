# frozen_string_literal: true

require_relative 'db_university'

class StudentsListDB
  def initialize
    self.db = DBUniversity.instance
  end

  def student_by_id(student_id)
    hash = db.prepare_exec('SELECT * FROM student WHERE id = ?', student_id).first
    return nil if hash.nil?

    Student.from_hash(hash)
  end

  # Получить page по счету count элементов (страница начинается с 1)
  def paginated_short_students(page, count, existing_data_list: nil)
    offset = (page - 1) * count
    students = db.prepare_exec('SELECT * FROM student LIMIT ?, ?', offset, count)
    slice = students.map { |h| StudentShort.from_student(Student.from_hash(h)) }
    return DataListStudentShort.new(slice) if existing_data_list.nil?

    existing_data_list.append(*slice)
    existing_data_list
  end

  def add_student(student)
    template = 'INSERT INTO student(last_name, first_name, father_name, phone, telegram, email, git) VALUES (?, ?, ?, ?, ?, ?, ?)'
    db.prepare_exec(template, *student_fields(student))
    db.query('SELECT LAST_INSERT_ID()').first.first[1]
  end

  def replace_student(student_id, student)
    template = 'UPDATE student SET last_name=?, first_name=?, father_name=?, phone=?, telegram=?, email=?, git=? WHERE id=?'
    db.prepare_exec(template, *student_fields(student), student_id)
  end

  def remove_student(student_id)
    db.prepare_exec('DELETE FROM student WHERE id = ?', student_id)
  end

  def student_count
    db.query('SELECT COUNT(id) FROM student').first.first[1]
  end

  private

  attr_accessor :db

  def student_fields(student)
    [student.last_name, student.first_name, student.father_name, student.phone, student.telegram, student.email, student.git]
  end
end
