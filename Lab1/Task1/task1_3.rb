puts "Введи команду языка ruby"
cmd_ruby = STDIN.gets.chomp
system "ruby -e \"#{cmd_ruby}\""

puts "Отлично! А теперь введи команду ОС"
cmd_os = STDIN.gets.chomp
system cmd_os