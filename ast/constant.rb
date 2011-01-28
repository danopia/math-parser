require './ast/node'

module AST
  class Constant < Node
    attr_accessor :value
    
    def initialize value
      @value = value
    end
    
    def + other
      if other.is_a? Constant
        AST::Constant.new(@value + other.to_i)
      else
        super
      end
    end
    
    def * other
      if other.is_a? Constant
        AST::Constant.new(@value * other.to_i)
      else
        super
      end
    end
    
    def / other
      if other.is_a? Constant
        AST::Ratio.new(@value, other.to_i)
      else
        super
      end
    end
    
    def ** power
      if power.is_a? Constant
        AST::Constant.new(@value ** power.to_i)
      else
        super
      end
    end
    
    def hash; @value.hash; end
    
    def monomial?; true; end
    def constant?; true; end
    
    def to_s; @value.to_s; end
    def to_i; @value.to_i; end
    
    def inspect
      "#<AST::Constant #{@value}>"
    end
  end
end

