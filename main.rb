# @author Rosalinda Chamale, Jack Schmid, Carl Fukawa, Ricky Fok
require 'ruby2d'
require_relative 'button'
require_relative 'display'
require_relative 'priceCalculation'
require_relative 'shoppingItem'

# Set the window size, background color, and title
set width: 600, height: 560
set background: '#376278'
set title: "Shopping Calculator"

@displayX = 600
@displayY = 40

# Create the display

Display.new(0, 0, @displayX , @displayY , "#505050", "Enter State Abbreviation") # main typing display
Display.new(0, 40, @displayX , @displayY , "#505050", "") # Amount Saved 
Display.new(0, 80, @displayX , @displayY + 40 , "#505050", "") # Items
Display.new(0, 160, @displayX , @displayY , "#505050", "") # Subtotal
Display.new(0, 200, @displayX , @displayY , "#505050", "") # Total

@displaceVal = 160  # for button displacement
@absTotal = 0 # for sumTotal

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
        when 10, 13
            color = 'silver'
        else
            color = 'white'
        end
        if button_num == 38
            buttons[button_num] = Button.new(j * 60, ((i + 1) * 80) + @displaceVal, 120, 80, color, 
                @button_names[button_num])
        else
            buttons[button_num] = Button.new(j * 60, ((i + 1) * 80)+ @displaceVal, 60, 80, color, 
                @button_names[button_num])
        end
    end
end

def reset()
    @stateLabel = true
    @itemLabel = true
    @quantityLabel = true
    @priceLabel = true
    @saleLabel = true
    @first = true
    @state = ''
    @name = ''
    @quant = ''
    @price = ''
    @sale = ''
    @itemDisplay = ''

    @grandTotal = 0
    @grandSubtotal = 0
    @grandSaved = 0

    @items = []
end

reset()

def input(input)
  if @button_names.include? input # State Abbr. Input
        input_num = @button_names.find_index(input)
        if @stateLabel
            case input_num
            when 10..28, 30..36   # Letters
                @state += input
                Display.new(0, 0, @displayX, @displayY, "#505050", @state)
            when 29   # backspace
                if @state.length > 0
                    @state = @state[0...-1]
                    #Display.new(0, 0, 600, 80, "#505050", @state)
                end

                if @state.length == 0   # if set back to nothing
                      Display.new(0, 0, @displayX, @displayY, "#505050",  "Enter State Abbreviation")
                    else
                      Display.new(0, 0, @displayX, @displayY, "#505050",  @state)
                    end

            when 38   # enter
                if !@state.eql?('')
                    if @first
                      Display.new(0, 40, @displayX , @displayY , "#505050",
                                "State: " + @state) 
                    end
                    Display.new(0, 0, @displayX, @displayY, "#505050", "Enter Sale %")
                    @stateLabel = false
                end
            end
         elsif @saleLabel    # Sale % Input
            case input_num
            when 0..9   # Numbers
                if @sale.eql?('0') && input_num == 9
                elsif @sale.eql?('0') && input_num != 9
                    @sale = input
                elsif @sale.length < 2
                    @sale += input
                elsif @sale.eql?('10') && input_num == 9
                    @sale += input
                end
                Display.new(0, 0, @displayX, @displayY,  "#505050", @sale + " %")
            when 29     # Backspace
                if @sale.length > 0
                    @sale = @sale[0...-1]
                    if @sale.eql?('0')
                        @sale = ''
                    end

                    if @sale.length == 0   # if set back to nothing
                        Display.new(0, 0, @displayX, @displayY, "#505050",  "Enter Sale %")
                    else
                        Display.new(0, 0, @displayX, @displayY, "#505050",  @sale + " %")
                    end
                end
            when 38 # Enter
                if !@sale.eql?('')
                    @saleLabel = false
                    Display.new(0, 0, @displayX, @displayY,  "#505050", "Enter Item Name")
                end
            end
        elsif @itemLabel    # Entering item name
            case input_num
            when 0..9   # Numbers
                #@name += input
                Display.new(0, 0,@displayX, @displayY, "#505050", "Item name cannot contain numbers.")
            when 10..28, 30..37   # Letters
                @name += input
                Display.new(0, 0, @displayX, @displayY, "#505050", @name)

            when 29     # Backspace             
                if @name.length > 0
                    @name = @name[0...-1]
                end

                  if @name.length == 0   # if set back to nothing
                        Display.new(0, 0, @displayX, @displayY,  "#505050",  "Enter Item Name")
                  else
                        Display.new(0, 0, @displayX, @displayY,  "#505050", @name)
                  end
      
            when 38   # Enter
                if !@name.eql?('') && @name.length > 2
                    Display.new(0, 0, @displayX, @displayY,  "#505050", "Enter Quantity of " + @name)
                    @itemLabel = false
                else
                    Display.new(0, 0, @displayX, @displayY,  "#505050", "Item name is too short")
                end
            end

        elsif @quantityLabel  # reads in quantity of item
            case input_num
            when 0..9   # Numbers
                @quant += input
                Display.new(0, 0,@displayX, @displayY, "#505050", @quant)
            when 29     # Backspace             
                if @quant.length > 0
                    @quant = @quant[0...-1]
                    if @quant.eql?('0')
                        @quant = ''
                    end

                    if @quant.length == 0   # if set back to nothing
                        Display.new(0, 0, @displayX, @displayY,  "#505050",  "Enter Quantity of " + @name)
                    else
                        Display.new(0, 0, @displayX, @displayY,  "#505050",  @quant)
                    end
                end
             when 38   # Enter
                if !@quant.eql?('')
                    Display.new(0, 0, @displayX, @displayY,  "#505050", "Enter Price of 1x " + @name)
                    @quantityLabel = false
                end
            end
        elsif @priceLabel   # Price Input
            case input_num
            when 0..9   # Numbers
                if @price.eql?('') && input_num == 9
                elsif !@price.include?('.') || @price[-1] == '.' || @price[-2] == '.'
                    @price += input
                end
                Display.new(0, 0,@displayX, @displayY, "#505050", '$' + @price)
            when 29     # Backspace             
                if @price.length > 0
                    @price = @price[0...-1]
                    if @price.eql?('0')
                        @price = ''
                    end

                    if @price.length == 0   # if set back to nothing
                        Display.new(0, 0, @displayX, @displayY,  "#505050",  "Enter Price of 1x " + @name)
                    else
                        Display.new(0, 0, @displayX, @displayY,  "#505050",  '$' + @price)
                    end
                end
            when 37   # Period
                if @price.eql?('')
                    @price = '0.'
                    Display.new(0, 0, @displayX, @displayY,  "#505050", '$' + @price)
                elsif !@price.include?('.')
                    @price += '.'
                    Display.new(0, 0, @displayX, @displayY,  "#505050",'$' +  @price)
                end
            when 38   # Enter
                if !@price.eql?('')
                    @priceLabel = false
                    begin
                        subtotal, total, saved = calculate(@state, (@price.to_f) * @quant.to_i, @sale.to_i)
                        subtotal = @grandSubtotal + subtotal
                        total = @grandTotal + total
                        if saved.nil?
                            saved = @grandSaved
                        else
                            saved = @grandSaved + saved
                        end
                        puts total
                        final = "Item Added"
                        Display.new(0, 0, @displayX , @displayY , "#505050", final)
                        Display.new(0, 40, @displayX , @displayY , "#505050", "Amount Saved: $%.2f" % [saved])
                        Display.new(0, 160, @displayX , @displayY , "#505050", "Subtotal: $%.2f" % [subtotal])
                        Display.new(0, 200, @displayX , @displayY , "#505050", "Total: $%.2f" % [total]) 
                        
                        @grandTotal = total
                        @grandSubtotal = subtotal
                        @grandSaved = saved 
    
                        temp = ShoppingItem.new(@name, @price.to_f, @quant.to_i)
                        @name = ''
                        @price = ''
                        @quant = ''
                        @itemDisplay = @itemDisplay + temp.printLabel() + ", "                
                        Display.new(0, 80, @displayX , @displayY + 40 , "#505050", @itemDisplay) # Item
                    rescue => e
                        final = e.message + ', Enter correct state abbreviation'
                        Display.new(0, 0, @displayX , @displayY , "#505050", final)
                        reset()
                    end
                end
            end
        else
            case input_num
            when 10 # Q to quit
                close
            when 13 # R to reset
                reset()
                Display.new(0, 0, @displayX , @displayY , "#505050", "Enter State Abbreviation") # main typing display
                Display.new(0, 40, @displayX , @displayY , "#505050", "") # Amount Saved 
                Display.new(0, 80, @displayX , @displayY + 40 , "#505050", "") # Items
                Display.new(0, 160, @displayX , @displayY , "#505050", "") # Subtotal
                Display.new(0, 200, @displayX , @displayY , "#505050", "") # Total
            when 38 # Enter to add more items
                @priceLabel = true
                @saleLabel = true
                @quantityLabel = true
                @itemLabel = true
                @price = ''
                @sale = ''
                @first = false
                Display.new(0, 0, @displayX , @displayY , "#505050", "Enter Sale %")

            end
        end
    end
end

click = Sound.new('mixkit-mouse-click-close-1113.wav')
cash = Sound.new('mixkit-coins-handling-1939.wav')

# On Key release
on :key_up do |event|

    input = event.key

    # Parse keypad inputs
    if input.include? 'keypad'
        input = input.sub('keypad ', '')
        click.play()
    end

    if input.eql?('backspace')
        input('<--')
        click.play()
    elsif input.eql?('return')
        input('ENTER')
        cash.play()
    else
        input(input.upcase)
        click.play()
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
                if i == 38
                    cash.play()
                else
                    puts i
                    click.play()
                end
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
