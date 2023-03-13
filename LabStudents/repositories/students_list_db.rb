# frozen_string_literal: true

class StudentsListDB
  def initialize(db_config)
    self.client = Mysql2::Client.new(db_config)

    client.query_options.merge!(symbolize_keys: true)
  end

  def student_by_id(student_id)
    hash = client.prepare('SELECT * FROM student WHERE id = ?').execute(student_id).first
    return nil if hash.nil?

    Student.from_hash(hash)
  end

  # Получить page по счету count элементов (страница начинается с 1)
  def paginated_short_students(page, count, existing_data_list: nil)
    offset = (page - 1) * count
    students = client.prepare('SELECT * FROM student LIMIT ?, ?').execute(offset, count)
    slice = students.map { |h| StudentShort.from_student(Student.from_hash(h)) }
    return DataListStudentShort.new(slice) if existing_data_list.nil?

    existing_data_list.append(*slice)
    existing_data_list
  end

  def add_student(student)
    stmt = client.prepare('INSERT INTO student(last_name, first_name, father_name, phone, telegram, email, git) VALUES (?, ?, ?, ?, ?, ?, ?)')
    stmt.execute(*student_fields(student))
    client.query('SELECT LAST_INSERT_ID()').first.first[1]
  end

  def replace_student(student_id, student)
    stmt = client.prepare('UPDATE student SET last_name=?, first_name=?, father_name=?, phone=?, telegram=?, email=?, git=? WHERE id=?')
    stmt.execute(*student_fields(student), student_id)
  end

  def remove_student(student_id)
    stmt = client.prepare('DELETE FROM student WHERE id = ?')
    stmt.execute(student_id)
  end

  def student_count
    client.query('SELECT COUNT(id) FROM student').first.first[1]
  end

  private

  attr_accessor :client

  def student_fields(student)
    [student.last_name, student.first_name, student.father_name, student.phone, student.telegram, student.email, student.git]
  end
end
