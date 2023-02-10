# frozen_string_literal: true

require_relative 'student'

class DataTable
  # Преобразование студента в массив полей
  def self.student_to_array(student)
    [
      student.id,
      student.last_name,
      student.first_name,
      student.father_name,
      student.phone,
      student.telegram,
      student.email,
      student.git
    ]
  end

  private

  attr_accessor :table
  attr_writer :columns_count

  public

  attr_reader :columns_count

  # Конструктор, принимает любое кол-во студентов

  def initialize(*students)
    self.columns_count = 8
    self.table = []
    students.each { |student| table.append(DataTable.student_to_array(student)) }
  end

  # Получение строки по её индексу
  def get_row(row_number)
    table[row_number].clone
  end

  # Получение строки по полю 'id' студента
  def get_row_by_student_id(id)
    table.each do |row|
      return row.clone if row[0] == id
    end

    nil
  end

  # Получение текущего кол-ва строк в таблице
  def rows_count
    table.size
  end

  def to_s
    "DataTable (#{rows_count} rows)"
  end
end
