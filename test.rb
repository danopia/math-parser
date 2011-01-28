require './parser'

parser = MathParser.new

#maths = '5x^(2)y^2x+5z'
#maths = '1+2*3+4^2'
#maths = 'x^3+2x^2+4'
#maths = '123'

token_tests = {
  # Ints
  '1' => '1',
  '12' => '12',
  '123' => '123',
  '01' => '01', # TODO
  
  # Decimals
  '1.1' => '1.1',
  '1.10' => '1.10',
  #'1.1.1' => nil, # not validated when tokenizing
  
  # Basic operations
  '1+1' => ['1', :+, '1'],
  '1*1' => ['1', :*, '1'],
  '1**1' => nil,
  '1+2+3' => [['1', :+, '2'], :+, '3'],
  '1+2*3' => ['1', :+, ['2', :*, '3']],
  
  # Parens
  '(1' => nil,
  '1)' => nil,
  '(1)' => ['1'],
  '(1)+(2)' => [['1'], :+, ['2']],
  '(1+2)*3' => [['1', :+, '2'], :*, '3'],
  '(1+2)3' => [['1', :+, '2'], :*, '3'],
  '(1+2)(1-2)' => [['1', :+, '2'], :*, ['1', :-, '2']],
  '10(1+2)11(1-2)12' => [[[['10', :*, ['1', :+, '2']], :*, '11'], :*, ['1', :-, '2']], :*, '12'],
  
  # Exponents
  '10^2' => ['10', :^, '2'],
  '10^2*5' => [['10', :^, '2'], :*, '5'],
  '10^2(5)' => [['10', :^, '2'], :*, ['5']],
  '10^(2*5)' => ['10', :^, ['2', :*, '5']],
  '10^(2*5)3' => [['10', :^, ['2', :*, '5']], :*, '3'],
  '(4+5)^(2*5)3' => [[['4', :+, '5'], :^, ['2', :*, '5']], :*, '3'],
  '(2^2)^2' => [['2', :^, '2'], :^, '2'],
  '2^2^2' => ['2', :^, ['2', :^, '2']],
  
  # Signs
  '-3' => '-3',
  '2+-1' => ['2', :+, '-1'],
  '2*-1' => ['2', :*, '-1'],
  '2*--1' => nil,
  '2+(-1)' => ['2', :+, ['-1']],
  
  # Variables
  'x' => 'x',
  '2x' => ['2', :*, 'x'],
  'x^2' => ['x', :^, '2'],
  'xy' => ['x', :*, 'y'],
  'x^(2)y' => [['x', :^, ['2']], :*, 'y'],
  '3xy' => [['3', :*, 'x'], :*, 'y'],
  
  # Equations
  # TODO!
}

pass = 0
token_tests.each_pair do |(expr, tokens)|
    res = nil
    begin
        res = parser.parse_raw(expr)
    rescue ParseError => e
        puts e.message if tokens
    end
    
    if res == tokens
        pass += 1
    else
        puts "[Token FAIL] #{expr} => #{res.inspect}: expected #{tokens.inspect}"
    end
end

puts "#{pass}/#{token_tests.size} token tests passed (#{((pass.to_f / token_tests.size)*100).to_i}%)"


eval_tests = {
  # Ints
  '1' => 1,
  '12' => 12,
  '123' => 123,
  '01' => 1,
  
  # Basics
  '1+1' => 2,
  '10(1+2)11(1-2)12' => -3960,
  
  # OoO
  '1+2*3' => 7,
  '3^2^2' => 81,
  
  # Variables
  '3x+2' => nil,
}

pass = 0
eval_tests.each_pair do |(expr, value)|
    res = parser.parse(expr) rescue nil
    
    if res.to_i == value
        pass += 1
    else
        puts "[Eval  FAIL] #{expr} => #{res.to_i.inspect}: expected #{value.inspect}"
    end
end

puts "#{pass}/#{eval_tests.size} evaluation tests passed (#{((pass.to_f / eval_tests.size)*100).to_i}%)"

begin
    res = parser.parse('4x=2')
    puts "#{res} => #{res.solve}"
rescue ParseError => e
    puts e.message if tokens
end

