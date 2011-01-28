# coding: utf-8
require './ast/node_factory'
require './char_reader'

class MathParser
    def parse_raw string
        reader = CharReader.new string
        tokens = tokenize reader
        clarify tokens
    end
    
    def parse string
        AST::NodeFactory.build(parse_raw(string))
    end
    
    def tokenize reader, root=true
        tokens = []
        token = nil
        
        ops = ['+', '*', '-', '/', '^']
        unipowers = {'¹' => 1, '²' => 2, '³' => 3}
        
        reader.read_to_end do |c|
            if c == '('
                tokens << token << :* if token
                token = tokenize(reader, false)
            elsif c == ')'
                reader.raise 'Encountered ) without matching (' if root
                reader.raise 'Trailing operator in quantity' if !token
                return tokens << token
            elsif (c == '-' || c == '+') && !token
                token = c
            elsif (c == '-' || c == '+') && (token == '-' || token == '+')
                reader.raise 'Double-signs are not legal syntax'
            elsif ops.include?(c) || unipowers.has_key?(c)
                reader.raise 'Missing number before operator' if !token && tokens.empty?
                reader.raise 'Double operators are not legal syntax' if !token
                if ops.include?(c)
                  tokens << token << c.to_sym
                  token = nil
                else
                  tokens << token << :'^'
                  token = [unipowers[c]]
                end
            elsif c == '='
                reader.raise 'Missing number before equality' if !token && tokens.empty?
                reader.raise 'Double operators are not legal syntax' if !token
                reader.raise 'Equality signs can only go at the top-most level' if !root
                reader.raise 'Each expression may only have one equality sign' if tokens.include?(:'=')
                tokens << token << c.to_sym
                token = nil
            elsif ('a'..'z').include?(c)
                tokens << token << :* if token
                token = c
            elsif ('0'..'9').include?(c) || c == '.'
                if token && !token.is_a?(String)
                    tokens << token << :*
                    token = nil
                end
                token = (token || '') + c
            else
                reader.raise 'Unknown charactor'
            end
        end
        
        reader.raise 'Extra opening parenthesis in input' if reader.eof? && !root
        
        tokens << token if token
        tokens
    end
    
    def clarify tokens
      if tokens.size == 1
        return tokens.first
      elsif tokens.size == 3
        return tokens
      elsif (tokens.size / 2).to_i * 2 == tokens.size
        raise 'lolwtf' # it's even!?
      end
      
      precedence = [[:'^'], [:'*', :'/'], [:'+', :'-'], [:'=']]
      precedence.each do |ops|
        operators = tokens.select{|t| t.is_a? Symbol }
        next if ops.select{|op| operators.include? op}.empty?
        
        rtl = (ops == [:'^']) # 2^2^2 == 2^(2^2)
        i = rtl ? (operators.size - 1) : 0
        while i < operators.size && i >= 0 && tokens.size > 3
          op = operators[i]
          
          if ops.include? op
            operators.slice! i
            tokens.insert(i*2, [tokens[i*2], op, tokens[i*2 +2]])
            tokens.slice! i*2 +1, 3
          else
            i += 1 if !rtl
          end
          i -= 1 if rtl
        end
        
        break if tokens.size <= 3
      end
      
      return tokens
    end
end

