require 'ast/node'

module AST
  class Constant < Node
    attr_accessor :value
    
    def initialize value
      @value = value
    end
    
    def + other
      if other.constant?
        AST::Constant.new(@value + other.to_i)
      else
        raise StandardError, "Addition of #{self.class.to_s} and #{other.class.to_s} is not implemented"
      end
    end
    
    def * other
      if other.constant?
        AST::Constant.new(@value * other.to_i)
      else
        raise StandardError, "Multiplication of #{self.class.to_s} and #{other.class.to_s} is not implemented"
      end
    end
    
    def ** power
      if power.constant?
        AST::Constant.new(@value ** power.to_i)
      else
        raise StandardError, "Bases of #{self.class.to_s} aren't able to be raised to powers of #{power.class.to_s} yet"
      end
    end
    
    def hash; value.hash; end
    
    def monomial?; true; end
    def constant?; true; end
    
    def to_s; @value.to_s; end
    def to_i; @value.to_i; end
    
    def inspect
      "#<AST::Constant #{@value}>"
    end
  end
end

