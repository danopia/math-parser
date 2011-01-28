require './ast/node_factory'

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
      self + -other
    end
    
    def * other
      if self.constant? && other.constant?
        AST::Operation.new self.to_i, :*, other.to_i
      else
        raise "Multiplication between #{self.class} and #{other.class} isn't defined"
      end
    end
    
    def / other
      if self.constant? && other.constant?
        AST::Operation.new self.to_i, :/, other.to_i
      else
        raise "Division between #{self.class} and #{other.class} isn't defined"
      end
    end
    
    def ** other
      if self.constant? && other.constant?
        AST::Operation.new self.to_i, :^, other.to_i
      else
        raise "Exponents between #{self.class} and #{other.class} aren't defined"
      end
    end
    
    
    def reciprocal
      return NodeFactory.build(1/to_i) if constant? # TODO: precision!
      raise "#{self.class} doesn't know how to find its own reciprocal"
    end
    
    def -@
      return NodeFactory.build(-to_i) if constant?
      raise "#{self.class} doesn't know how to flip its sign"
    end

    
    def simplify
      constant? ? NodeFactory.build(to_i) : self
    end
  end
end

