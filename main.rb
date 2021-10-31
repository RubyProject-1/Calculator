# @author Rosalinda Chamale, Jack Schmid, Carl Fukawa
require 'ruby2d'
require_relative 'button'
require_relative 'display'
require_relative 'calculator'

# Set the window size, background color, and title
set width: 240, height: 480
set background: '#376278'
set title: "Calculator"

# Create the display
Display.new(0, 0, 240, 80, "#505050", "")

@calculator = Calculator.new()

button_names = ['**', 'c', '<--', '/', '7', '8', '9', '*', '4', '5', '6', '-',
    '1', '2', '3', '+', '+/-', '0', '.', '=']

# Create the buttons
buttons = []

for i in 0..4
    for j in 0..3
        button_num = 4* i + j
        case button_num
        when 4..6, 8..10, 12..14, 16..18
            color = 'white'
        else
            color = '#FF9500'
        end
        buttons[button_num] = Button.new(j * 60, (i + 1) * 80, 60, 80, color, 
            button_names[button_num])
    end
end

@defaultLabel = true

# For numeric inputs
def numberIn(num)
    if @defaultLabel && !@calculator.val1 # Start val1
        if num.eql?('<--') || num.eql?('c') || num.eql?('+/-')
            return
        end
        if num .eql? '.'
            @input = '0.'
        else
            @input = num
        end
        @defaultLabel = false
        if num .eql? '.'
            @calculator.val1 = @input.to_f
        else
            @calculator.val1 = @input.to_i
        end
        Display.new(0, 0, 240, 80, "#505050", @input)
    elsif !@defaultLabel && !@calculator.val2 # Add to val1
        if @calculator.val1.is_a?(Integer) && @calculator.val1 == 0 # Cannot append to 0
            if num .eql? '.'
                @input = '0'
            else
                @input = ''
            end
        end
        if num .eql? '<--'
            @input = @input[0...-1] # Perform backspace
        elsif num .eql? 'c'
            @input = ''             # Clear number
        elsif num.eql?('+/-') && @calculator.val1 != 0
            if @calculator.val1 > 0
                @input = '-' + @input
            else
                @input = @input[1..-1]
            end
        elsif num .eql? '+/-'
            return
        else
            @input += num
        end
        if @input .include? '.'
            @calculator.val1 = @input.to_f
        else
            @calculator.val1 = @input.to_i
        end
        Display.new(0, 0, 240, 80, "#505050", @input)
    elsif @defaultLabel && !@calculator.val2  # Start val2
        if num.eql?('<--') || num.eql?('c')
            return
        end
        if num .eql? '.'
            @input = '0.'
        else
            @input = num
        end
        @defaultLabel = false
        if num .eql? '.'
            @calculator.val2 = @input.to_f
        else
            @calculator.val2 = @input.to_i
        end
        Display.new(0, 0, 240, 80, "#505050", @input)
    else # Add to val2
        if @calculator.val2.is_a?(Integer) && @calculator.val2 == 0 # Cannot append to 0
            if num .eql? '.'
                @input = '0'
            else
                @input = ''
            end
        end
        if num .eql? '<--'
            @input = @input[0...-1] # Perform backspace
        elsif num .eql? 'c'
            @input = ''             # Clear number
        elsif num.eql?('+/-') && @calculator.val2 != 0
            if @calculator.val2 > 0
                @input = '-' + @input
            else
                @input = @input[1..-1]
            end
        elsif num .eql? '+/-'
            return
        else
            @input += num
        end
        if @input .include? '.'
            @calculator.val2 = @input.to_f
        else
            @calculator.val2 = @input.to_i
        end
        Display.new(0, 0, 240, 80, "#505050", @input)
    end
end

# For symbol inputs
def symbolIn(symbol)
    if @calculator.val1 && !@calculator.val2 # Set operation
        case symbol
        when '**'
            @calculator.op = '**'
        when '+'
            @calculator.op = '+'
        when '-'
            @calculator.op = '-'
        when '*'
            @calculator.op = '*'
        when '/'
            @calculator.op = '/'
        end
        case symbol
        when '**', '+', '-', '*', '/'
            Display.new(0, 0, 240, 80, "#505050", "")
            @defaultLabel = true
        end
    elsif @calculator.val1 && @calculator.val2 # Get the result
        case symbol
        when 'enter', 'return', '='
            case @calculator.op
            when '**'
                @calculator.pow
            when '+'
                @calculator.add
            when '-'
                @calculator.sub
            when '*'
                @calculator.mul
            when '/'
                @calculator.div
            end
            case @calculator.op
            when '**', '+', '-', '*', '/'
                Display.new(0, 0, 240, 80, "#505050", @calculator.val1)
                @input = @calculator.val1.to_s
            end
        end
    end
end

# On Key release
on :key_up do |event|

    input = event.key

    # Parse keypad inputs
    if input.include? 'keypad'
        input = input.sub('keypad ', '')
    end

    # Keypad functions
    symbolIn(input)

    # Special numeric inputs
    if input .eql? 'backspace'
        numberIn('<--')
    elsif input .eql? 'c' # Clear number
        numberIn(input)
    elsif input .eql? '.'
        numberIn('.')
    end

    # Parse numeric inputs
    begin Integer(input) # Try to get Integer
        numberIn(input)
    rescue
        next # Except anything else
    end
end

# On mouse click
on :mouse_down do |event|
    # Left mouse button pressed down
    if event.button == :left
        x = event.x
        y = event.y
        for i in 0..19
            # Perform a button's action if it is clicked
            if buttons[i].inRect(x, y)
                case i
                when 0, 3, 7, 11, 15, 19
                    symbolIn(buttons[i].label_name)
                when 1, 2, 4..6, 8..10, 12..14, 16..18
                    numberIn(buttons[i].label_name)
                end
            end
        end
    end
end

# Highlights a button when the mouse hovers over it
update do
    x = get :mouse_x
    y = get :mouse_y
    for i in 0..19
        if x != 0 && x != 239 && y != 0 && y != 479 && buttons[i].inRect(x, y)
            buttons[i].color = 'yellow'
        else
            buttons[i].reset_color
        end
        buttons[i].draw
    end
end

show
