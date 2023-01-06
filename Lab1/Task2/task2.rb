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

# 2. Количество цифр числа, меньших 3
def less_than_3_cnt(number)
  result = 0
  number.digits.each { |dig| result += 1 if dig < 3 }
  result
end

# 3. Количество чисел, не являющихся делителями исходного числа, не взамнопростых с ним и взаимно простых с суммой простых цифр этого числа
def cool_numbers_cnt(number)
  result = 0
  prime_sum = 0
  number.digits.each { |dig| prime_sum += dig if prime?(dig) }
  number.downto(2).each { |i| result += 1 unless (number % i).zero? || i.gcd(number) == 1 || i.gcd(prime_sum) != 1 }
  result
end

puts 'Введите число:'
x = $stdin.gets.to_i
puts "Сумма непростых делителей: #{sum_np_div(x)}"
puts "Количество цифр, меньших 3: #{less_than_3_cnt(x)}"
puts "Количество чисел задания №3: #{cool_numbers_cnt(x)}"
