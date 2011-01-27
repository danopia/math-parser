module AST
  class Node
    def + other
      AST::Operation.new self, :+, other
    end
    
    def * other
      AST::Operation.new self, :*, other
    end
    
    def ** other
      AST::Operation.new self, :^, other
    end
  end
end

