# @author Rosalinda Chamale, Jack Schmid, Carl Fukawa
require 'ruby2d'
require_relative 'button'
require_relative 'display'
require_relative 'calculator'
require_relative 'priceCalculation'

# Set the window size, background color, and title
set width: 600, height: 400
set background: '#376278'
set title: "Calculator"

# Create the display
Display.new(0, 0, 600, 80, "#505050", "Enter State Abbreviation")

@calculator = Calculator.new()

@button_names = ['1','2', '3', '4', '5', '6', '7', '8', '9', '0', 
    'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 
    'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', '<--', 
    'Z', 'X', 'C', 'V', 'B', 'N', 'M', '.', 'ENTER']

# Create the buttons
buttons = []

for i in 0..3
    for j in 0..9
        button_num = 10 * i + j
        if button_num == 39
            break
        end
        case button_num
        when 0..9, 29, 37, 38
            color = '#FF9500'
        else
            color = 'white'
        end
        if button_num == 38
            buttons[button_num] = Button.new(j * 60, (i + 1) * 80, 120, 80, color, 
                @button_names[button_num])
        else
            buttons[button_num] = Button.new(j * 60, (i + 1) * 80, 60, 80, color, 
                @button_names[button_num])
        end
    end
end

@stateLabel = true
@priceLabel = true
@saleLabel = true
@state = ''
@price = ''
@sale = ''

# For inputs
def input(input)
    if @button_names.include? input
        input_num = @button_names.find_index(input)
        if @stateLabel
            case input_num
            when 10..28, 30..36
                @state += input
                Display.new(0, 0, 600, 80, "#505050", @state)
            when 29
                if @state.length > 0
                    @state = @state[0...-1]
                    Display.new(0, 0, 600, 80, "#505050", @state)
                end
            when 38
                if !@state.eql?('')
                    Display.new(0, 0, 600, 80, "#505050", "Enter Price")
                    @stateLabel = false
                end
            end
        elsif @priceLabel
            case input_num
            when 0..9
                if @price.eql?('') && input_num == 9
                elsif !@price.include?('.') || @price[-1] == '.' || @price[-2] == '.'
                    @price += input
                end
                Display.new(0, 0, 600, 80, "#505050", @price)
            when 29
                if @price.length > 0
                    @price = @price[0...-1]
                    if @price.eql?('0')
                        @price = ''
                    end
                    Display.new(0, 0, 600, 80, "#505050", @price)
                end
            when 37
                if @price.eql?('')
                    @price = '0.'
                    Display.new(0, 0, 600, 80, "#505050", @price)
                elsif !@price.include?('.')
                    @price += '.'
                    Display.new(0, 0, 600, 80, "#505050", @price)
                end
            when 38
                if !@price.eql?('')
                    Display.new(0, 0, 600, 80, "#505050", "Enter Sale %")
                    @priceLabel = false
                end
            end
        elsif @saleLabel
            case input_num
            when 0..9
                if @sale.eql?('') && input_num == 9
                elsif @sale.length < 2
                    @sale += input
                elsif @sale.eql?('10') && input_num == 9
                    @sale += input
                end
                Display.new(0, 0, 600, 80, "#505050", @sale)
            when 29
                if @sale.length > 0
                    @sale = @sale[0...-1]
                    if @sale.eql?('0')
                        @sale = ''
                    end
                    Display.new(0, 0, 600, 80, "#505050", @sale)
                end
            when 38
                if !@sale.eql?('')
                    @saleLabel = false
                    begin
                        subtotal, total, saved = calculate(@state, @price.to_f, @sale.to_i)
                        final = "subtotal: $%.2f, saved: $%.2f, total: $%.2f" % [subtotal, saved, total]
                    rescue => e
                        final = e.message
                    end
                    Display.new(0, 0, 600, 80, "#505050", final)
                end
            end
        else
            case input_num
            when 38
                @stateLabel = true
                @priceLabel = true
                @saleLabel = true
                Display.new(0, 0, 600, 80, "#505050", "Enter State Abbreviation")
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

    if input.eql?('backspace')
        input('<--')
    elsif input.eql?('return')
        input('ENTER')
    else
        input(input.upcase)
    end
end

# On mouse click
on :mouse_down do |event|
    # Left mouse button pressed down
    if event.button == :left
        x = event.x
        y = event.y
        for i in 0..buttons.length() - 1
            # Perform a button's action if it is clicked
            if buttons[i].inRect(x, y)
                input(buttons[i].label_name)
            end
        end
    end
end

# Highlights a button when the mouse hovers over it
update do
    x = get :mouse_x
    y = get :mouse_y
    for i in 0..buttons.length() - 1
        if x != 0 && x != 599 && y != 0 && y != 399 && buttons[i].inRect(x, y)
            buttons[i].color = 'yellow'
        else
            buttons[i].reset_color
        end
        buttons[i].draw
    end
end

show
