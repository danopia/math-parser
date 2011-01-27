require 'parser'

parser = MathParser.new

while true
    print '>> '
    STDOUT.flush
    
    begin
      res = parser.parse(gets.chomp)
    rescue ParseError => e
      puts e.message
    end
    
    begin
      puts "=> #{res.to_i}"
    rescue => e
      puts e, e.backtrace
    end
end

