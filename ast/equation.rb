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
      right = @right.to_num.to_s if @right.is_a? Ratio
      "#{@left} = #{right || @right}"
    end
    
    def inspect
      "#<AST::Equation #{@left.inspect} = #{@right.inspect}>"
    end
    
    def simplify
      Equation.new @left.simplify, @right.simplify
    end
    
    def solve
      return @left.to_i == @right.to_i if constant?
      
      variable, constant = @left, @right
      constant, variable = variable, constant if variable.constant?
      #raise 'as if...' if !constant.constant?
      
      until variable.is_a? Variable
        #p variable
        #sleep 1
        #puts Equation.new(variable, constant)
        
        if variable.is_a? Constant
          raise 'this should never happen'
        elsif variable.is_a? Quantity
          variable = variable.child
        elsif variable.is_a? Operation
          if variable.symbol == :'*'
            if variable.left.constant?
              constant = constant / variable.left
              variable = variable.right
            elsif variable.right.constant?
              constant = constant / variable.right
              variable = variable.left
            end
          elsif variable.symbol == :'+'
            if variable.left.constant?
              constant = constant - variable.left
              variable = variable.right
            elsif variable.right.constant?
              constant = constant - variable.right
              variable = variable.left
            end
          elsif variable.symbol == :'-'
            if variable.left.constant?
              constant = variable.left - constant
              variable = variable.right
            elsif variable.right.constant?
              constant = constant + variable.right
              variable = variable.left
            end
          end
        elsif variable.is_a? Ratio
          if variable.top.constant?
            variable, constant = constant, variable
            variable *= constant.bottom
            constant = constant.top
          elsif variable.bottom.constant?
            constant *= variable.bottom
            variable = variable.top
          end
        else
          raise "The solver doesn't understand how to handle a #{variable.class} yet"
        end
      end
      
      Equation.new variable, constant
    end
  end
end

