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

def cycle_triple_shift_left(arr)
  arr.rotate(3)
end

def elements_before_first_min(arr)
  stop_elem = arr.min
  arr[0, arr.index(stop_elem)]
end

def check_local_max(arr, idx)
  idx = Integer(idx)
  return false unless idx.between?(1, arr.length - 2)

  arr[idx - 1] <= arr[idx] and arr[idx + 1] <= arr[idx]
end

def elements_less_than_avg(arr)
  avg = arr.sum / arr.length.to_f
  arr.filter { |x| x < avg }
end

def elements_more_than_3_times(arr)
  arr.filter { |x| arr.count(x) > 3 }.uniq
end

methods = %i[
  cycle_triple_shift_left
  elements_before_first_min
  check_local_max
  elements_less_than_avg
  elements_more_than_3_times
]
option = gets.chomp.to_i
unless option.between?(1, methods.length)
  puts 'Неизвестный метод'
  return
end

my_method = method(methods[option - 1])
additional_args = []
(my_method.arity - 1).times do |i|
  print "Аргумент №#{i + 1}: "
  additional_args << gets
end

result = my_method.call(arr, *additional_args)
puts "Результат: #{result.inspect}"
