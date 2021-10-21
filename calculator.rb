# @author Rosalinda Chamale, Jack Schmid, Carl Fukawa
require 'ruby2d'
require_relative 'button'
require_relative 'display'

# Set the window size
set width: 240, height: 480
# Set the background color
set background: '#376278'
# Set the window title
set title: "Calculator"

# Create the display
display = Display.new(0, 0, 240, 80, "#505050", "")

# Create the buttons
buttons = []

# Use 2d programatic creation
for i in 0..4
    for j in 0..3
        case i * 4 + j
        when 0
            string = '**'
        when 1
            string = 'c'
        when 2
            string = '<--'
        when 3
            string = '/'
        when 4
            string = '7'
        when 5
            string = '8'
        when 6
            string = '9'
        when 7
            string = '*'
        when 8
            string = '4'
        when 9
            string = '5'
        when 10
            string = '6'
        when 11
            string = '-'
        when 12
            string = '1'
        when 13
            string = '2'
        when 14
            string = '3'
        when 15
            string = '+'
        when 16
            string = '+/-'
        when 17
            string = '0'
        when 18
            string = '.'
        when 19
            string = '='
        end
        buttons[i * 4 + j] = Button.new(j * 60, (i + 1) * 80, 60, 80, "#FF9500", string)
    end
end

defaultLabel = true

# On Key release, if not 0-9, wont be added
on :key_up do |event|

    string = event.key
    
    # Parse keypad inputs
    if string.include? 'keypad'
        string = string.sub('keypad ', '')
    end

    # Keypad functions
    if @val1 && !@val2 # Set operation
        case string
        when '+'
            @op = '+'
            display = Display.new(0, 0, 240, 80, "#505050", "")
            defaultLabel = true
        when '-'
            @op = '-'
            display = Display.new(0, 0, 240, 80, "#505050", "")
            defaultLabel = true
        when '*'
            @op = '*'
            display = Display.new(0, 0, 240, 80, "#505050", "")
            defaultLabel = true
        when '/'
            @op = '/'
            display = Display.new(0, 0, 240, 80, "#505050", "")
            defaultLabel = true
        end
    elsif @val1 && @val2 # Get the result
        case string
        when 'enter' || 'return'
            case @op
            when '+'
                @val1 += @val2
                display = Display.new(0, 0, 240, 80, "#505050", @val1)
                remove_instance_variable(:@val2)
            when '-'
                @val1 -= @val2
                display = Display.new(0, 0, 240, 80, "#505050", @val1)
                remove_instance_variable(:@val2)
            when '*'
                @val1 *= @val2
                display = Display.new(0, 0, 240, 80, "#505050", @val1)
                remove_instance_variable(:@val2)
            when '/'
                @val1 /= @val2
                display = Display.new(0, 0, 240, 80, "#505050", @val1)
                remove_instance_variable(:@val2)
            end
        end
    end

    # Parse numeric inputs
    begin Integer(string) # Try to get Integer

        if defaultLabel && !@val1 # Start val1
            defaultLabel = false
            @input = string
            @val1 = @input.to_i
            display = Display.new(0, 0, 240, 80, "#505050", @input)
        elsif !defaultLabel && !@val2 # Add to val1
            if @val1 == 0 # Cannot append to 0
                next
            end
            @input += string
            @val1 = @input.to_i
            display = Display.new(0, 0, 240, 80, "#505050", @input)
        elsif defaultLabel && !@val2 # Start val2
            defaultLabel = false
            @input = string
            @val2 = @input.to_i
            display = Display.new(0, 0, 240, 80, "#505050", @input)
        else # Add to val2
            if @val2 == 0 # Cannot append to 0
                next
            end
            @input += string
            @val2 = @input.to_i
            display = Display.new(0, 0, 240, 80, "#505050", @input)
        end
    rescue
        next # Except anything else
    end
end

# On mouse click check if a button contains the mouse position, if it does do that buttons function
on :mouse_down do |event|
    # Left mouse button pressed down
    if event.button == :left
        buttonPress = true
        @valueOne = @input.to_i
        # Save the first value entered to be used later
        if buttons[1].getRect().contains? event.x, event.y
            puts '+'
        elsif buttons[2].getRect().contains? event.x, event.y
            puts '-'
        elsif buttons[3].getRect().contains? event.x, event.y
            puts 'x'
        elsif buttons[4].getRect().contains? event.x, event.y
            puts '/'
        elsif buttons[5].getRect().contains? event.x, event.y
            puts '^'
        elsif buttons[6].getRect().contains? event.x, event.y
            puts '='
        else
            buttonPress = false
        end
    end
end

show
