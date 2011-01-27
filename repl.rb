require './parser'

parser = MathParser.new

trap('INT') do
  puts if STDOUT.tty?
  exit
end

while true
  if STDOUT.tty?
    print '>> '
    STDOUT.flush
  end
  
  line = gets
  exit unless line
  next if line.empty?
  begin
    res = parser.parse(line.chomp)
  rescue ParseError => e
    puts e.message
  end
  
  begin
    puts "=> #{res.to_i || res}"
  rescue => e
    puts e, e.backtrace
  end
end

