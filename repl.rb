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
  next if line.chomp!.empty?
  
  res = nil
  begin
    res = parser.parse(line)
  rescue ParseError => e
    puts e.message
    next
  end
  
  begin
    simple = res.simplify
    stack = [res.to_s, simple.to_s]
    stack << res.to_i.to_s if res.constant?
    
    (stack.size - 2).downto(0) do |i|
      stack.slice! i if stack[i] == stack[i+1]
    end
    
    puts "=> #{stack.join ' = '}"
  rescue => e
    puts e, e.backtrace
  end
end

