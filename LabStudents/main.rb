# frozen_string_literal: true

require_relative 'models/student'
require_relative 'models/student_short'
require_relative 'repositories/containers/data_table'
require_relative 'repositories/containers/data_list_student_short'
require_relative 'repositories/data_sources/file_data_source'
require_relative 'repositories/data_sources/transformers/data_transformer_json'
require_relative 'repositories/data_sources/transformers/data_transformer_yaml'
require_relative 'repositories/student_repository'
require_relative 'repositories/adapters/file_source_adapter'
require_relative 'repositories/adapters/db_source_adapter'
require 'json'
require 'yaml'
require 'mysql2'

student1 = Student.new('Иванов', 'Иван', 'Иванович')
student2 = Student.new('Сараев', 'Поджог', 'Равшанович', id: 1, telegram: 'nightfire')
student3 = Student.new('Обоев', 'Рулон', 'Джамшутович', phone: '79997775533', email: 'wallpapers@mail.ru', git: 'roboyev')
student4 = Student.new('Пингвинов', 'Косяк', 'Олегович', id: 3, phone: '79990001122', telegram: 'pngn', email: 'antarctica@gmail.com', git: 'iampngn')

student2.set_contacts(email: 'mrfire@bk.ru', phone: '79876543210')

puts student1
puts "Valid: #{student1.valid?}"
puts student2
puts "Valid: #{student2.valid?}"
puts student3
puts "Valid: #{student3.valid?}"
puts student4
puts "Valid: #{student4.valid?}"

def test_invalid_options(**options)
  Student.new('Иванов', 'Иван', 'Иванович', **options)
rescue ArgumentError => e
  puts e.message
end

test_invalid_options(phone: '123123')
test_invalid_options(phone: '799966622')
test_invalid_options(phone: 'iphone')
test_invalid_options(phone: '11111111111')
test_invalid_options(email: 'hello@world')
test_invalid_options(telegram: 'вася пупкин')

puts '--------------------------------'

student5 = Student.new('Голубев', 'Доброжир', 'Братиславович', id: 4, email: 'gold@mail.ru', git: 'zhirbrother')
puts student5.to_json_str

puts Student.from_json_str('{"first_name": "Сергеев", "last_name": "Сергей", "father_name": "Сергеевич", "id": 5, "phone": "79996665544"}')

begin
  Student.from_json_str('{"first_name": "Петя", "email":"pe@tya.com"}')
rescue ArgumentError => e
  puts "Тест 1: #{e.message}"
end

begin
  Student.from_json_str('{"first_name": "Куков", "last_name": "Айфон", "father_name": "Степанович", "id": 5, "phone": "123123123"}')
rescue ArgumentError => e
  puts "Тест 2: #{e.message}"
end

begin
  Student.from_json_str('Петя')
rescue JSON::ParserError => e
  puts "Тест 3: #{e.message}"
end

puts '--------------------------------'

puts student5.short_info

short1 = StudentShort.from_student(student5)
puts short1

puts '--------------------------------'

test_matrix = [[1, 'Petya', true], [2, 'Igor', false]]
test_table = DataTable.new(test_matrix)
puts test_table
puts test_table.get_item(0, 1)

short2 = StudentShort.from_student(student2)
short3 = StudentShort.from_student(student4)

short_list = DataListStudentShort.new([short1, short2, short3])

short_table = short_list.data_table
puts short_table

short_list.select_element(2)
puts "Вырбан элемент #2 с id=#{short_list.selected_id}"

print 'id'.ljust(45)
short_list.column_names.each { |col_name| print col_name.ljust(45) }
puts

0.upto(short_table.rows_count - 1) do |row|
  0.upto(short_table.cols_count - 1) do |col|
    item = short_table.get_item(row, col)
    print item.to_s.ljust(45)
  end
  puts
end

puts '--------------------------------'
puts 'Тест формирования StudentShort из строк таблицы:'

0.upto(short_table.rows_count - 1) do |row|
  stud_info = {}
  1.upto(short_table.cols_count - 1) do |col|
    stud_info[short_list.column_names[col - 1].to_sym] = short_table.get_item(row, col)
  end

  my_student = StudentShort.new(short_table.get_item(row, 0), JSON.generate(stud_info))
  puts my_student
end

short_list.objects = []
puts short_list.data_table

puts '--------------------------------'
def test_repository(student_rep)
  puts "В репозитории #{student_rep.student_count} студентов."
  puts "Студент с id=1: #{student_rep.student_by_id(1)}"
  test_student = Student.new('Арабов', 'Адам', 'Анатольевич', telegram: 'adam_arabov', git: 'arab_dev')
  puts "Добавляем студента: #{test_student}"
  added_id = student_rep.add_student(test_student)
  puts "Добавили. Теперь студентов #{student_rep.student_count}. Его id: #{added_id}. Пробуем получить: "
  puts student_rep.student_by_id(added_id)
  test_student.telegram = 'ne_otdam_arabov'
  puts 'Заменяем телеграм студента...'
  student_rep.replace_student(added_id, test_student)
  puts student_rep.student_by_id(added_id)
  puts "Удаляем студента с id=#{added_id}..."
  student_rep.remove_student(added_id)
  puts "Удалили. Теперь студентов #{student_rep.student_count}"
  puts 'Тест пагинации: '
  puts 'Страница 1:'
  puts student_rep.paginated_short_students(1, 3).data_table.inspect
  puts 'Страница 2:'
  puts student_rep.paginated_short_students(2, 3).data_table.inspect
end

puts
puts '=> Тест StudentRepository (JSON) <='
rep_json = StudentRepository.new(FileSourceAdapter.new(DataTransformerJSON.new, './LabStudents/test_data/students.json'))
test_repository(rep_json)

puts
puts '=> Тест StudentRepository (YAML) <='
rep_yaml = StudentRepository.new(FileSourceAdapter.new(DataTransformerYAML.new, './LabStudents/test_data/students.yaml'))
test_repository(rep_yaml)

puts
puts '=> Тест StudentRepository (DB) <='
rep_yaml = StudentRepository.new(DBSourceAdapter.new)
test_repository(rep_yaml)
