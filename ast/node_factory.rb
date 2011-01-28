require './ast/node'
require './ast/operation'
require './ast/equation'
require './ast/quantity'
require './ast/constant'
require './ast/variable'

module AST
  class NodeFactory
    def self.build raw
      return raw if raw.is_a? Node
      
      if raw.is_a? Array
        if raw.size == 3
          return Equation.new(raw[0], raw[2]) if raw[1] == :'='
          Quantity.new(Operation.new(*raw))
        elsif raw.size == 1
          Quantity.new(build(raw[0]))
        else
          raise 'wtf is this array for?' unless raw.is_a? Array
        end
      
      elsif raw.is_a? String
        if ('a'..'z').include?(raw)
          Variable.new raw
        else
          Constant.new raw.to_i
        end
      
      elsif raw.is_a? Fixnum
        Constant.new raw
      
      else
        p raw
        raise 'wtf is this?'
      end
    end
  end
end

