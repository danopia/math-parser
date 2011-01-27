require 'ast/node'
require 'ast/constant'
require 'ast/node_factory'

module AST
  class Term < Node
    attr_accessor :coefficient, :variables
    
    def initialize coefficient=nil
      @coefficient = NodeFactory.build(coefficient || 1)
      @variables = Hash.new {Constant.new(0)} # default to 0
    end
    
    def []= letter, power
      @variables[letter.to_sym] = NodeFactory.build power
    end
    
    def + other
      raise StandardError, "Addition of #{self.class.to_s} and #{other.class.to_s} is not implemented"
    end
    
    def * other
      raise StandardError, "Multiplication of #{self.class.to_s} and #{other.class.to_s} is not implemented"
    end
    
    def hash; to_s.hash; end
    
    def to_s
      str = @variables.map do |(letter, power)|
        (power.coefficient.to_i == 1) ? letter : "#{letter}^(#{power})"
      end.join('')
      
      if @variables.size == 0 || @coefficient.to_i != 1
        return "#{@coefficient}#{str}"
      end
      
      str
    end
    
    def monomial?
      return false unless @coefficient.constant?
      
      @variables.reject do |letter, power|
        power.constant?
      end.empty?
    end
    
    def inspect
      "#<AST::Term #{to_s}>"
    end
    
    def constant?
      @variables.empty?
    end
    
    def to_i
      throw StandardError, 'Non-constant terms can not be converted to a constant number' unless constant?
      @coefficient.to_i
    end
  end
end

