require 'ast/node'
require 'ast/node_factory'

module AST
  class Quantity < Node
    attr_accessor :child
    
    def initialize child=nil
      @child = NodeFactory.build child
    end
    
    def to_s
      "(#{@child})"
    end
    
    def to_i; @child.to_i; end

    def hash; child.hash + 1; end
    
    def constant?; @child.constant?; end
    def monomial?; @child.monomial?; end
    
    def inspect
      "#<AST::Quantity #{@child.inspect}>"
    end
  end
end

