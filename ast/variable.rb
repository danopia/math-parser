require 'ast/node'

module AST
  class Variable < Node
    attr_accessor :letter
    
    def initialize letter
      @letter = letter
    end
    
    def * other
      if other.is_a?(Variable) && @letter == other.letter
        AST::Operation.new(self, :^, 2)
      else
        super
      end
    end
    
    def hash; @letter.hash; end
    
    def monomial?; true; end
    def constant?; false; end
    
    def to_s; @letter.to_s; end
    def to_i; nil; end
    
    def inspect
      "#<AST::Variable #{@letter}>"
    end
  end
end

