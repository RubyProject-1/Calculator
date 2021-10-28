# @author Carl Fukawa
class Calculator

    attr_accessor :val1 # Creates getters and setters 
    attr_accessor :val2 # for these class varialbles
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
        if @val2 != 0 # No divide by zero
            @val1 /= @val2
        end
        remove_instance_variable(:@val2)
    end

end
