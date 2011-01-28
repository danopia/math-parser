# coding: utf-8
require './ast/node'
require './ast/node_factory'

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
      return 1 if @symbol == :'^' && @right.to_i == 0 # special case
      
      case @symbol
        when :'+'; @left +  @right
        when :'-'; @left -  @right
        when :'*'; @left *  @right
        when :'/'; @left /  @right
        when :'^'; @left ** @right
        else; raise 'Unknown operation'
      end.to_i
    end
    
    def op_name
      case @symbol
        when :'+'; 'Addition'
        when :'-'; 'Subtraction'
        when :'*'; 'Multiplication'
        when :'/'; 'Division'
        when :'^'; 'Power'
        else; raise 'Unknown operation'
      end
    end
    
    def + other
      if @symbol == :'/'
        Operation.new(@left + (other.to_i * @right), @symbol, @right)
      else
        super
      end
    end
    
    def - other
      if @symbol == :'/'
        Operation.new(@left - (other.to_i * @right), @symbol, @right)
      else
        super
      end
    end
    
    def * other
      if @symbol == :'/' && other.is_a?(Operation) && other.symbol == :'/'
        Operation.new(@left * other.left, @symbol, @right * other.right)
      else
        super
      end
    end
    
    def / other
      if @symbol == :'/' && other.is_a?(Operation) && other.symbol == :'/'
        Operation.new(@left * other.right, @symbol, @right * other.left)
      elsif @symbol == :'/'
        Operation.new(@left, @symbol, @right * other.to_i)
      else
        super
      end
    end
    
    def constant?
      return true if @symbol == :'^' && @right.constant? && @right.to_i == 0 # special case
      @left.constant? && @right.constant?
    end
    
    def hash; @left.hash*2 + @symbol.hash + @right.hash*3; end
    
    def to_s
      if @symbol == :'^'
        return left.to_s if @right.to_i == 1
        return "#{@left}²" if @right.to_i == 2
        return "#{@left}³" if @right.to_i == 3
      end
      
      "#{@left} #{@symbol} #{@right}"
    end
    
    def inspect
      "#<AST::Operation::#{op_name} #{@left.inspect} #{@right.inspect}>"
    end
    
    def simplify
      return NodeFactory.build(to_i) if constant?
      Operation.new @left.simplify, @symbol, @right.simplify
    end
  end
end

