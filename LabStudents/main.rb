# frozen_string_literal: true

require_relative 'models/student'
require_relative 'models/student_short'
require_relative 'repositories/containers/data_table'
require_relative 'repositories/containers/data_list_student_short'
require_relative 'repositories/students_list'
require_relative 'repositories/transformers/data_transformer_json'
require_relative 'repositories/transformers/data_transformer_yaml'
require 'json'

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
puts 'Тест StudentsList (JSON):'

stud_list_json = StudentsList.new(DataTransformerJSON.new)
stud_list_json.add_student(student1)
stud_list_json.add_student(student2)
stud_list_json.add_student(student3)
stud_list_json.add_student(student4)
stud_list_json.add_student(student5)
stud_list_json.save_to_file('./LabStudents/test_data/students.json')

stud_list_json.load_from_file('./LabStudents/test_data/students.json')

puts "Успешно записано и прочитано #{stud_list_json.student_count} студентов:"

1.upto(stud_list_json.student_count).each { |id| puts stud_list_json.student_by_id(id) }

puts 'Вывод студентов по страницам из 2х человек: '
pages_count = (stud_list_json.student_count / 2.0).ceil
1.upto(pages_count) do |page|
  puts "Страница #{page} / #{pages_count}:"
  page_data = stud_list_json.paginated_short_students(page, 2)
  print('id'.ljust(50))
  page_data.column_names.each { |col_name| print col_name.ljust(50) }
  puts
  table = page_data.data_table
  (0...table.rows_count).each do |row|
    (0...short_table.cols_count).each do |col|
      print table.get_item(row, col).to_s.ljust(50)
    end
    puts
  end
end

puts '--------------------------------'
puts 'Тест StudentsList (YAML):'

stud_list_yaml = StudentsList.new(DataTransformerYAML.new)
stud_list_yaml.add_student(student1)
stud_list_yaml.add_student(student2)
stud_list_yaml.add_student(student3)
stud_list_yaml.add_student(student4)
stud_list_yaml.add_student(student5)

stud_list_yaml.save_to_file('./LabStudents/test_data/students.yaml')
stud_list_yaml.load_from_file('./LabStudents/test_data/students.yaml')
puts "Успешно записано и прочитано #{stud_list_yaml.student_count} студентов"
