# frozen_string_literal: true

file_path = './Lab1/Task4/array.txt'
file = File.open(file_path)
arr = file.readline.split(' ').map(&:to_i)

puts "Прочитан массив из #{arr.length} элементов:"
puts arr.inspect
puts 'Выберите действие:'
puts "\t1. Циклический сдвиг на 3 влево"
puts "\t2. Элементы до первого минимального"
puts "\t3. Проверить лок. максимум по индексу"
puts "\t4. Элементы, меньшие среднего"
puts "\t5. Элементы, встречающиеся более 3 раз"

def method6(arr)
  arr.rotate(3)
end

def method18(arr)
  stop_elem = arr.min
  arr[0, arr.index(stop_elem)]
end

def method30(arr)
  puts 'Индекс проверки лок. максимума:'
  test_idx = gets.chomp.to_i
  return false unless test_idx.between?(1, arr.length - 2)

  arr[test_idx - 1] <= arr[test_idx] and arr[test_idx + 1] <= arr[test_idx]
end

def method42(arr)
  avg = arr.sum / arr.length.to_f
  puts "Среднее арифметическое: #{avg}"
  arr.filter { |x| x < avg }
end

def method54(arr)
  arr.filter { |x| arr.count(x) > 3 }.uniq
end

methods = %i[method6 method18 method30 method42 method54]
option = gets.chomp.to_i
unless option.between?(1, methods.length)
  puts 'Неизвестный метод'
  return
end

result = method(methods[option - 1]).call(arr)
puts "Результат: #{result.inspect}"
