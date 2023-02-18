# frozen_string_literal: true

require_relative 'student'
require_relative 'student_short'
require_relative 'data_table'

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
