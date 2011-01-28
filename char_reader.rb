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
    
    def rewind
        return nil if @index <= 0
        @index -= 1
        @string[@index, 1]
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

