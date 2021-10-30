# @author Carl Fukawa
class Calculator

    attr_accessor :val1 # Creates getters and setters 
    attr_accessor :val2 # for these class varialbles
    attr_accessor :op

    def initialize()
    end

    def add
        @val1 += @val2
        cleanup
    end

    def sub
        @val1 -= @val2
        cleanup
    end

    def mul
        @val1 *= @val2
        cleanup
    end

    def div
        if @val2 != 0 # No divide by zero
            @val1 /= @val2.to_f
        end
        cleanup
    end

    def pow
        @val1 **= @val2.to_f
        cleanup
    end

    private
    def cleanup
        if @val1 % 1 == 0
            @val1 = @val1.to_i
        end
        remove_instance_variable(:@val2)
    end

end
