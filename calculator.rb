# @author Carl Fukawa
class Calculator

    attr_accessor :val1
    attr_accessor :val2
    attr_accessor :op

    def initialize()
    end

    def add
        @val1 += @val2
        remove_instance_variable(:@val2)
    end

    def sub
        @val1 -= @val2
        remove_instance_variable(:@val2)
    end

    def mul
        @val1 *= @val2
        remove_instance_variable(:@val2)
    end

    def div
        @val1 /= @val2
        remove_instance_variable(:@val2)
    end

end
