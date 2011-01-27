require 'ast/node_factory'

module AST
  class Node
    def + other
      if self.constant? && other.constant?
        AST::Operation.new self.to_i, :+, other.to_i
      else
        raise "Addition between #{self.class} and #{other.class} isn't defined"
      end
    end
    
    def - other
      if other.constant?
        self + NodeFactory.build(-other.to_i)
      else
        raise "Subtraction between #{self.class} and #{other.class} isn't defined"
      end
    end
    
    def * other
      if self.constant? && other.constant?
        AST::Operation.new self.to_i, :*, other.to_i
      else
        raise "Multiplication between #{self.class} and #{other.class} isn't defined"
      end
    end
    
    def / other
      if other.constant?
        self * NodeFactory.build(1/other.to_i)
      else
        raise "Divison between #{self.class} and #{other.class} isn't defined"
      end
    end
    
    def ** other
      if self.constant? && other.constant?
        AST::Operation.new self.to_i, :^, other.to_i
      else
        raise "Exponents between #{self.class} and #{other.class} aren't defined"
      end
    end
  end
end

