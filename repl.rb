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
  
  res = nil
  begin
    res = parser.parse(line.chomp)
  rescue ParseError => e
    puts e.message
    next
  end
  
  begin
    i = res.to_i
    puts "=> #{(i === nil) ? res : i}"
  rescue => e
    puts e, e.backtrace
  end
end

