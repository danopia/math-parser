#require 'ast/term'

class ParseError < StandardError; end

class MathParser
    def parse string
        reader = CharReader.new string
        tokens = tokenize reader
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
                raise ParserError, 'Encountered ) without matching (' if root
                tokens << token if token.any?
                return tokens
            elsif (c == '-' || c == '+') && !token
                token = c
            elsif (c == '-' || c == '+') && (token == '-' || token == '+')
                raise ParseError, 'Double-signs are not legal syntax'
            elsif ops.include? c
                raise ParseError, 'Double operators are not legal syntax' if !token
                tokens << token
                tokens << c.to_sym
                token = nil
            elsif !token
                token = c
            elsif token.is_a? Array
                tokens << token << :*
                token = c
            elsif ('0'..'9').include? c
                token += c
            elsif c == '.'
                raise ParseError, 'Decimals may only have one decimal point' if token.include? '.'
                token += c
            end
        end
        
        raise ParserError, 'Extra opening parenthesis in input' if reader.eof? && !root
        
        tokens << token if token.any?
        tokens
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
        return nil if eof?
        @string[@index + 1, 1]
    end
    
    def read_to_end
        yield read until eof?
    end
    
    def eof?; @index >= @string.size; end
    def remaining; @string.size - @index; end
end

