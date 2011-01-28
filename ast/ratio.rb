require './ast/node'
require './ast/node_factory'

module AST
  class Ratio < Node
    attr_accessor :top, :bottom
    
    def initialize top, bottom
      @top = NodeFactory.build top
      @bottom = NodeFactory.build bottom
    end
    
    def to_i
      return nil unless constant?
      return 0 if @top.constant? && @top.to_i == 0
      
      self # for now
    end
    
    def + other
      Ratio.new(@top + (other * @bottom), @bottom)
    end
    
    def - other
      Ratio.new(@top - (other * @bottom), @bottom)
    end
    
    def * other
      if other.is_a? Ratio
        Ratio.new(@top * other.top, @bottom * other.bottom)
      else
        Ratio.new(@top * other, @bottom)
      end
    end
    
    def / other
      if other.is_a? Ratio
        Ratio.new(@top * other.bottom, @bottom * other.top)
      else
        Ratio.new(@top, @bottom * other)
      end
    end
    
    def constant?
      return true if @top.constant? && @top.to_i == 0
      @top.constant? && @bottom.constant?
    end
    
    def hash; @top.hash*2 + @bottom.hash*4; end
    
    def to_s
      "#{@top} / #{@bottom}"
    end
    
    def to_num
      return simplify if !constant?
      
      if (@top.to_i % @bottom.to_i) == 0
        @top.to_i / @bottom.to_i
      else
        @top.to_i.to_f / @bottom.to_i
      end
    end
    
    def inspect
      "#<AST::Ratio #{@top.inspect} / #{@bottom.inspect}>"
    end
    
    def simplify
      return NodeFactory.build(to_i) if constant?
      return @top.simplify if @bottom.constant? && @bottom == 1
      Ratio.new @top.simplify, @bottom.simplify
    end
  end
end

