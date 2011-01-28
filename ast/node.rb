require './ast/node_factory'

module AST
  class Node
    def + other
      if other.is_a? Ratio
        other.to_i + self.to_i
      elsif self.constant? && other.constant?
        AST::Operation.new self.to_i, :+, other.to_i
      else
        AST::Operation.new self, :+, other
      end
    end
    
    def - other
      self + -other
    end
    
    def * other
      if other.is_a? Ratio
        other * self
      elsif self.constant? && other.constant?
        AST::Operation.new self.to_i, :*, other.to_i
      else
        AST::Operation.new self, :*, other
      end
    end
    
    def / other
      if self.constant? && other.is_a?(Ratio)
        AST::Ratio.new(self.to_i * other.right, other.left)
      elsif self.constant? && other.constant?
        AST::Ratio.new self.to_i, other.to_i
      else
        AST::Ratio.new self, other
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

