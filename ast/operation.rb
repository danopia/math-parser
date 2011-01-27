require 'ast/node'
require 'ast/node_factory'

module AST
  class Operation < Node
    attr_accessor :left, :symbol, :right
    
    def initialize left, symbol, right
      @left = NodeFactory.build left
      @symbol = symbol.to_sym
      @right = NodeFactory.build right
    end
    
    def + other
      raise StandardError, "Addition of #{self.class.to_s} and #{other.class.to_s} is not implemented"
    end
    
    def * other
      raise StandardError, "Multiplication of #{self.class.to_s} and #{other.class.to_s} is not implemented"
    end
    
    def ** power
      raise StandardError, "Bases of #{self.class.to_s} aren't able to be raised to powers of #{power.class.to_s} yet"
    end
    
    def to_i
      case @symbol
        when :'+': @left +  @right
        when :'-': @left -  @right
        when :'*': @left *  @right
        when :'/': @left /  @right
        when :'^': @left ** @right
      end.to_i
    end
    
    def op_name
      case @symbol
        when :'+': 'Addition'
        when :'-': 'Subtraction'
        when :'*': 'Multiplication'
        when :'/': 'Division'
        when :'^': 'Power'
      end
    end
    
    def constant?; @left.constant? && @right.constant?; end
    
    def hash; @left.hash*2 + @symbol.hash + @right.hash*3; end
    
    def to_s
      @children.join " #{@symbol} "
    end
    
    def inspect
      "#<AST::Operation::#{op_name} #{@left.inspect} #{@right.inspect}>"
    end
  end
end

