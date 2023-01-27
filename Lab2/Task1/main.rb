# frozen_string_literal: true

require_relative 'student'

student1 = Student.new('Иванов', 'Иван', 'Иванович')
student2 = Student.new('Ночной', 'Поджог', 'Сараев', id: 1, telegram: 'nightfire')
student3 = Student.new('Красивый', 'Рулон', 'Обоев', phone: '79997775533', email: 'wallpapers@mail.ru', git: 'roboyev')
student4 = Student.new('Мирный', 'Косяк', 'Пингвинов', id: 3, phone: '79990001122', telegram: 'pngn', email: 'antarctica@gmail.com', git: 'iampngn')

puts student1
puts student2
puts student3
puts student4
