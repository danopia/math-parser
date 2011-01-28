# coding: utf-8
require './ast/node'
require './ast/node_factory'

module AST
  class Equation < Node
    attr_accessor :left, :right
    
    def initialize left, right
      @left = NodeFactory.build left
      @right = NodeFactory.build right
    end
    
    def to_i
      return nil unless constant?
      
      (@left.to_i == @right.to_i) ? 1 : 0
    end
    
    def constant?
      @left.constant? && @right.constant?
    end
    
    def hash; @left.hash*2 + @right.hash*3; end
    
    def to_s
      "#{@left} = #{@right}"
    end
    
    def inspect
      "#<AST::Equation #{@left.inspect} = #{@right.inspect}>"
    end
    
    def simplify
      Equation.new @left.simplify, @right.simplify
    end
    
    def solve
      return @left.to_i == @right.to_i if constant?
      
      constant, variable = @left, @right
      constant, variable = variable, constant if variable.constant?
      raise 'as if...' if variable.constant?
      
      until variable.is_a? Variable
        #p variable
        #sleep 1
        
        if variable.is_a? Constant
          raise 'this should never happen'
        elsif variable.is_a? Quantity
          variable = variable.child
        elsif variable.is_a? Operation
          if variable.symbol == :'*'
            if variable.left.constant?
              constant = constant / variable.left
              variable = variable.right
            end
          end
        else
          raise "The solver doesn't understand how to handle a #{variable.class} yet"
        end
      end
      
      Equation.new variable, constant
    end
  end
end

