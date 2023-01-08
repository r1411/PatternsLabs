# frozen_string_literal: true

def min_elem(arr)
  return nil if arr.empty?

  min = arr[0]
  for x in arr
    min = x if x < min
  end
  min
end

def max_elem(arr)
  return nil if arr.empty?

  max = arr[0]
  for x in arr
    max = x if x > max
  end
  max
end

def first_positive_pos(arr)
  for i in 0..arr.length
    return i if arr[i] > 0
  end
  -1
end

if ARGV.count < 2
  puts 'Args: <method #> <file path>'
  return
end

methods = %i[min_elem max_elem first_positive_pos]
method_n = ARGV[0].to_i
file_path = ARGV[1]

unless method_n.between?(0, methods.length - 1)
  puts 'Неизвестный метод'
  return
end

file = File.open(file_path)
array = file.readline.split(' ').map(&:to_i)

puts "Массив: #{array}"
puts "Результат работы метода: #{method(methods[method_n]).call(array)}"
