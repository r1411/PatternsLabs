if ARGV.count < 1
  puts "Вы кто такие? Я Вас не звал!"
end

username = ARGV[0]
puts "Привет, #{username}!"

puts "Какой у тебя любимый язык программирования?"
lang = STDIN.gets.chomp.downcase
case lang
when "ruby"
  puts "Пользователь является подлизой!"
when "c++"
  puts "(__stdcall *)::Ничего<Скоро**, Будет&>::Ruby();"
when "c"
  puts "Ничего, скоро будет Ruby :)"
when "java"
  puts "Отлично, но скоро будет Ruby"
when "powerpoint"
  puts "Ладно.. Надеюсь, скоро будет Ruby!"
when "brainfuck"
  puts "--<-<<+[+[<+>--->->->-<<<]>]<<--.<++++++.<<-..<<.<+.>>.>>.<<<.+++.>>.>>-.<<<+ Ruby."
else
  puts "Скоро будет Ruby!"
end
