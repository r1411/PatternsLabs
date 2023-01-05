# frozen_string_literal: true

def prime?(number)
  return false if number <= 1
  return true if number == 2

  Math.sqrt(number).ceil.downto(2).each { |i| return false if (number % i).zero? }
  true
end

# 1. Сумма непростых делителей числа
def sum_np_div(number)
  sum = 0
  number.downto(1).each { |div| sum += div if (number % div).zero? && !prime?(div) }
  sum
end

puts 'Введите число:'
x = $stdin.gets.to_i
puts "Сумма непростых делителей: #{sum_np_div(x)}"
