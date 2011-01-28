require './parser'

parser = MathParser.new

trap('INT') do
  puts if STDOUT.tty?
  exit
end

while true
  if STDOUT.tty?
    print ' > '
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
    
    if res.is_a? AST::Equation
      stack << res.solve.to_s
    elsif res.constant?
      stack << res.to_i.to_s
    end
    
    (stack.size - 2).downto(0) do |i|
      stack.slice! i if stack[i] == stack[i+1]
    end
    
    stack.each do |line|
      puts "=> #{line}"
    end
  rescue => e
    puts e, e.backtrace
  end
end

