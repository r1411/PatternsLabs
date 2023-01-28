# frozen_string_literal: true

require_relative 'student'

student1 = Student.new('Иванов', 'Иван', 'Иванович')
student2 = Student.new('Сараев', 'Поджог', 'Равшанович', { id: 1, telegram: 'nightfire' })
student3 = Student.new('Обоев', 'Рулон', 'Джамшутович', { phone: '79997775533', email: 'wallpapers@mail.ru', git: 'roboyev' })
student4 = Student.new('Пингвинов', 'Косяк', 'Олегович', { id: 3, phone: '79990001122', telegram: 'pngn', email: 'antarctica@gmail.com', git: 'iampngn' })

puts student1
puts "Valid: #{student1.valid?}"
puts student2
puts "Valid: #{student2.valid?}"
puts student3
puts "Valid: #{student3.valid?}"
puts student4
puts "Valid: #{student4.valid?}"

def test_invalid_options(options)
  Student.new('Иванов', 'Иван', 'Иванович', options)
rescue ArgumentError => e
  puts e.message
end

test_invalid_options({ phone: '123123' })
test_invalid_options({ phone: '799966622' })
test_invalid_options({ phone: 'iphone' })
test_invalid_options({ phone: '11111111111' })
test_invalid_options({ email: 'hello@world' })
test_invalid_options({ telegram: 'вася пупкин' })
