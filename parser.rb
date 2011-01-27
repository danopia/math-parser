require 'ast/node_factory'

class ParseError < RuntimeError
    attr_accessor :reader, :message
    
    def initialize reader, message
        @reader = reader
        @message = message
    end
    
    def message
        "Syntax error at column #{@reader.index}: #{@message}\n" +
        "#{@reader.string}\n#{(' '*(@reader.index-1))}^"
    end
end

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
        reader.read_to_end do |c|
            if c == '('
                tokens << token << :* if token
                token = tokenize(reader, false)
            elsif c == ')'
                reader.raise 'Encountered ) without matching (' if root
                tokens << token if token.any?
                return tokens
            elsif (c == '-' || c == '+') && !token
                token = c
            elsif (c == '-' || c == '+') && (token == '-' || token == '+')
                reader.raise 'Double-signs are not legal syntax'
            elsif ops.include? c
                reader.raise 'Double operators are not legal syntax' if !token
                tokens << token << c.to_sym
                token = nil
            elsif !token
                token = c
            elsif token.is_a? Array
                tokens << token << :*
                token = c
            else
                token += c
            #elsif ('0'..'9').include? c
            #  token += c
            #elsif c == '.'
            #  reader.raise 'Decimals may only have one decimal point' if token.include? '.'
            #  token += c
            end
        end
        
        reader.raise 'Extra opening parenthesis in input' if reader.eof? && !root
        
        tokens << token if token.any?
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
      
      precedence = [[:'^'], [:'*', :'/'], [:'+', :'-']]
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

class CharReader
    attr_accessor :string, :index
    
    def initialize string='', index=0
        @string = string
        @index = index
    end
    
    def read
        return nil if eof?
        @index += 1
        @string[@index - 1, 1]
    end
    
    def peek
        eof? ? nil : @string[@index + 1, 1]
    end
    
    def read_to_end
        yield read until eof?
    end
    
    def eof?; @index >= @string.size; end
    def remaining; @string.size - @index; end
    
    def raise message
        Kernel.raise ParseError.new(self, message)
    end
end

