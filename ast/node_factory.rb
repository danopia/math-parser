require 'ast/node'
require 'ast/operation'
require 'ast/quantity'
require 'ast/constant'

module AST
  class NodeFactory
    def self.build raw
      return raw if raw.is_a? Node
      
      if raw.is_a? Array
        if raw.size == 3
          Quantity.new(Operation.new(*raw))
        elsif raw.size == 1
          Quantity.new(build(raw[0]))
        else
          raise 'wtf is this array for?' unless raw.is_a? Array
        end
      
      elsif raw.is_a? String
        Constant.new raw.to_i
      
      else
        raise 'wtf is this?'
      end
    end
  end
end

