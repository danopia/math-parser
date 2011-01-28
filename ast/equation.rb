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
      
      @left.to_i == @right.to_i
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
  end
end

