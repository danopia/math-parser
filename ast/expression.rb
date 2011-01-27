require './ast/node'
require './ast/node_factory'

module AST
  class Expression < Node
    attr_accessor :raw, :child
    
    def initialize raw
      @raw = raw
      @child = NodeFactory.build raw
    end
    
    def to_i; @child.to_i; end
    
    def inspect
      "#<AST::Expression #{@child.inspect}>"
    end
  end
end

