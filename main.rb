require 'parser'

#maths = '5x^(2)y^2x+5z'
#maths = '1+2*3+4^2'
#maths = 'x^3+2x^2+4'
#maths = '123'

# Unit Tests
maths = {
    # Ints
    '1' => ['1'],
    '12' => ['12'],
    '123' => ['123'],
    '01' => ['01'], # TODO
    
    # Decimals
    '1.1' => ['1.1'],
    '1.10' => ['1.10'],
    '1.1.1' => nil,
    
    # Basic operations
    '1+1' => ['1', :+, '1'],
    '1*1' => ['1', :*, '1'],
    '1**1' => nil,
    '1+2+3' => ['1', :+, '2', :+, '3'],
    '1+2*3' => ['1', :+, '2', :*, '3'],
    
    # Parens
    '(1' => nil,
    '1)' => nil,
    '(1)' => [['1']],
    '(1)+(2)' => [['1'], :+, ['2']],
    '(1+2)*3' => [['1', :+, '2'], :*, '3'],
    '(1+2)3' => [['1', :+, '2'], :*, '3'],
    '(1+2)(1-2)' => [['1', :+, '2'], :*, ['1', :-, '2']],
    '10(1+2)11(1-2)12' => ['10', :*, ['1', :+, '2'], :*, '11', :*, ['1', :-, '2'], :*, '12'],
    
    # Exponents
    '10^2' => ['10', :^, '2'],
    '10^2*5' => ['10', :^, '2', :*, '5'],
    '10^2(5)' => ['10', :^, '2', :*, ['5']],
    '10^(2*5)' => ['10', :^, ['2', :*, '5']],
    '10^(2*5)3' => ['10', :^, ['2', :*, '5'], :*, '3'],
    '(4+5)^(2*5)3' => [['4', :+, '5'], :^, ['2', :*, '5'], :*, '3'],
    
    '2^2^2' => ['2', :^, ['2', :^, '2']], # OoO
    '(2^2)^2' => [['2', :^, '2'], :^, '2'],
    
    # Signs
    '-3' => ['-3'],
    '2+-1' => ['2', :+, '-1'],
    '2*-1' => ['2', :*, '-1'],
    '2*--1' => nil,
    '2+(-1)' => ['2', :+, ['-1']],
}

pass = 0

parser = MathParser.new
maths.each_pair do |(expr, tokens)|
    res = parser.parse(expr) #rescue nil
    
    if res == tokens
        pass += 1
    else
        puts "#{expr} => #{res.inspect}: should get #{tokens.inspect} (FAIL)"
    end
end

puts "#{pass}/#{maths.size} passed (#{((pass.to_f / maths.size)*100).to_i}%)"

