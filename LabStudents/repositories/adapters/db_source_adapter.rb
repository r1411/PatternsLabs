# frozen_string_literal: true

require './LabStudents/repositories/data_sources/db_data_source'
require './LabStudents/models/student'
require './LabStudents/models/student_short'
require './LabStudents/repositories/containers/data_list_student_short'

class DBSourceAdapter
  def initialize
    @db = DBDataSource.instance
  end

  def student_by_id(student_id)
    hash = @db.prepare_exec('SELECT * FROM student WHERE id = ?', student_id).first
    return nil if hash.nil?

    Student.from_hash(hash)
  end

  def paginated_short_students(page, count, existing_data_list = nil)
    offset = (page - 1) * count
    students = @db.prepare_exec('SELECT * FROM student LIMIT ?, ?', offset, count)
    slice = students.map { |h| StudentShort.from_student(Student.from_hash(h)) }
    return DataListStudentShort.new(slice) if existing_data_list.nil?

    existing_data_list.replace_objects(slice)
    existing_data_list
  end

  def add_student(student)
    template = 'INSERT INTO student(last_name, first_name, father_name, phone, telegram, email, git) VALUES (?, ?, ?, ?, ?, ?, ?)'
    @db.prepare_exec(template, *student_fields(student))
    @db.query('SELECT LAST_INSERT_ID()').first.first[1]
  end

  def replace_student(student_id, student)
    template = 'UPDATE student SET last_name=?, first_name=?, father_name=?, phone=?, telegram=?, email=?, git=? WHERE id=?'
    @db.prepare_exec(template, *student_fields(student), student_id)
  end

  def remove_student(student_id)
    @db.prepare_exec('DELETE FROM student WHERE id = ?', student_id)
  end

  def student_count
    @db.query('SELECT COUNT(id) FROM student').first.first[1]
  end

  private

  def student_fields(student)
    [student.last_name, student.first_name, student.father_name, student.phone, student.telegram, student.email, student.git]
  end
end
