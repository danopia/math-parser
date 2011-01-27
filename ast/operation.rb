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
    
    def to_i
      return nil unless constant?
      
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
      "#{@left} #{@symbol} #{@right}"
    end
    
    def inspect
      "#<AST::Operation::#{op_name} #{@left.inspect} #{@right.inspect}>"
    end
  end
end

