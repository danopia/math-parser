require './ast/node'
require './ast/node_factory'

module AST
  class Exponent < Node
    attr_accessor :base, :power
    
    def initialize base=0, power=1
      @base = NodeFactory.build base
      @power = NodeFactory.build power
    end

    def * other
      if other.is_a?(Exponent) && @base = other.base
        Exponent.new @base, (@power + other.power)
      else
        throw StandardError, 'not implemented'
      end
    end

    
    def hash; @base.hash*2 + @power.hash; end # TODO: hacky
    
    def to_s
      (@power.coefficient == 1) ? @base : "#{@base}^(#{@power})"
    end
    
    def inspect
      "#<AST::Exponent base=#{@base.inspect} power=#{@power.inspect}>"
    end
    
    def to_i
#      throw StandardError, 'Non-constant terms can not be converted to a constant number' unless constant?
      @base.to_i ** @power.to_i
    end
  end
end

