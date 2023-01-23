# frozen_string_literal: true

file_path = './Lab1/Task4/array.txt'
file = File.open(file_path)
arr = file.readline.split(' ').map(&:to_i)

puts "Прочитан массив из #{arr.length} элементов:"
puts arr.inspect
puts 'Выберите действие:'
puts "\t1. Циклический сдвиг на 3 влево"
puts "\t2. Элементы до первого минимального"

def method6(arr)
  arr.rotate(3)
end

def method18(arr)
  stop_elem = arr.min
  arr[0, arr.index(stop_elem)]
end

methods = %i[method6 method18]
option = gets.chomp.to_i
unless option.between?(1, methods.length)
  puts 'Неизвестный метод'
  return
end

result = method(methods[option - 1]).call(arr)
puts "Результат: #{result.inspect}"
