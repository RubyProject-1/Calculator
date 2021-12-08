# @author Rosalinda Chamale, Jack Schmid, Carl Fukawa, Ricky Fok
require 'ruby2d'
require_relative 'button'
require_relative 'display'
require_relative 'priceCalculation'
require_relative 'shoppingItem'

# Set the window size, background color, and title
set width: 600, height: 660
set background: '#376278'#'#4f4f4f'
set title: "Shopping Calculator"

#Distance between sections of the calc, To make a little border around the whole thing and separate sections
@spacing = 10

@displayX = (get :width) - @spacing*2
@displayY = 50
@displayColor = "#819a9c" #@displayColor



# Create the display

Display.new(@spacing, @spacing, @displayX , @displayY , @displayColor, "Enter State Abbreviation") # main typing display
Display.new(@spacing, @spacing + @displayY*1, @displayX , @displayY , @displayColor, "") # Amount Saved 
Display.new(@spacing, @spacing + @displayY*2, @displayX , @displayY*2 , @displayColor, "") # Items
Display.new(@spacing, @spacing + @displayY*4, @displayX , @displayY , @displayColor, "") # Subtotal
Display.new(@spacing, @spacing + @displayY*5, @displayX , @displayY , @displayColor, "") # Total

@displaceVal = @displayY * 5  # for button displacement @displayY is heigh of buttons
@absTotal = 0 # for sumTotal

@button_names = ['1','2', '3', '4', '5', '6', '7', '8', '9', '0', 
                 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 
                 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', '<--', 
                 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '.', 'ENTER']

# Create the buttons
buttons = []
@buttonWidth = ((get :width) - @spacing*2) / 10
@buttonHeight = 80

for i in 0..3
    for j in 0..9
        button_num = 10 * i + j
        if button_num == 39
            break
        end
        case button_num
        when 0..9, 29, 37, 38
            color = '#54c1c7' #FF9500
        when 10, 13
            color = 'silver'
        else
            color = 'white'
        end
        if button_num == 38 
            #x y width height color label
            #Enter key, double the width
            buttons[button_num] = Button.new(j * @buttonWidth + @spacing, ((i + 1) * @buttonHeight) + @displaceVal, @buttonWidth*2, @buttonHeight, color, 
                @button_names[button_num])
        else
            buttons[button_num] = Button.new(j * @buttonWidth + @spacing, ((i + 1) * @buttonHeight) + @displaceVal, @buttonWidth, @buttonHeight, color, 
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
                Display.new(@spacing, @spacing, @displayX, @displayY, @displayColor, @state)
            when 29   # backspace
                if @state.length > 0
                    @state = @state[0...-1]
                    #Display.new(@spacing, @spacing, 600, 80, @displayColor, @state)
                end

                if @state.length == 0   # if set back to nothing
                      Display.new(@spacing, @spacing, @displayX, @displayY, @displayColor,  "Enter State Abbreviation")
                    else
                      Display.new(@spacing, @spacing, @displayX, @displayY, @displayColor,  @state)
                    end

            when 38   # enter
                if !@state.eql?('')
                    if @first
                        Display.new(@spacing, @spacing + @displayY, @displayX, @displayY , @displayColor,
                                "State: " + @state) 
                    end
                    Display.new(@spacing, @spacing, @displayX, @displayY, @displayColor, "Enter Sale %")
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
                Display.new(@spacing, @spacing, @displayX, @displayY,  @displayColor, @sale + " %")
            when 29     # Backspace
                if @sale.length > 0
                    @sale = @sale[0...-1]
                    if @sale.eql?('0')
                        @sale = ''
                    end

                    if @sale.length == 0   # if set back to nothing
                        Display.new(@spacing, @spacing, @displayX, @displayY, @displayColor,  "Enter Sale %")
                    else
                        Display.new(@spacing, @spacing, @displayX, @displayY, @displayColor,  @sale + " %")
                    end
                end
            when 38 # Enter
                if !@sale.eql?('')
                    @saleLabel = false
                    Display.new(@spacing, @spacing, @displayX, @displayY,  @displayColor, "Enter Item Name")
                end
            end
        elsif @itemLabel    # Entering item name
            case input_num
            when 0..9   # Numbers
                #@name += input
                Display.new(@spacing, @spacing, @displayX, @displayY, @displayColor, "Item name cannot contain numbers.")
            when 10..28, 30..37   # Letters
                @name += input
                Display.new(@spacing, @spacing, @displayX, @displayY, @displayColor, @name)

            when 29     # Backspace             
                if @name.length > 0
                    @name = @name[0...-1]
                end

                  if @name.length == 0   # if set back to nothing
                        Display.new(@spacing, @spacing, @displayX, @displayY,  @displayColor,  "Enter Item Name")
                  else
                        Display.new(@spacing, @spacing, @displayX, @displayY,  @displayColor, @name)
                  end
      
            when 38   # Enter
                if !@name.eql?('') && @name.length > 2
                    Display.new(@spacing, @spacing, @displayX, @displayY,  @displayColor, "Enter Quantity of " + @name)
                    @itemLabel = false
                else
                    Display.new(@spacing, @spacing, @displayX, @displayY,  @displayColor, "Item name is too short")
                end
            end

        elsif @quantityLabel  # reads in quantity of item
            case input_num
            when 0..9   # Numbers
                @quant += input
                Display.new(@spacing, @spacing,@displayX, @displayY, @displayColor, @quant)
            when 29     # Backspace             
                if @quant.length > 0
                    @quant = @quant[0...-1]
                    if @quant.eql?('0')
                        @quant = ''
                    end

                    if @quant.length == 0   # if set back to nothing
                        Display.new(@spacing, @spacing, @displayX, @displayY,  @displayColor,  "Enter Quantity of " + @name)
                    else
                        Display.new(@spacing, @spacing, @displayX, @displayY,  @displayColor,  @quant)
                    end
                end
             when 38   # Enter
                if !@quant.eql?('')
                    Display.new(@spacing, @spacing, @displayX, @displayY,  @displayColor, "Enter Price of 1x " + @name)
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
                Display.new(@spacing, @spacing,@displayX, @displayY, @displayColor, '$' + @price)
            when 29     # Backspace             
                if @price.length > 0
                    @price = @price[0...-1]
                    if @price.eql?('0')
                        @price = ''
                    end

                    if @price.length == 0   # if set back to nothing
                        Display.new(@spacing, @spacing, @displayX, @displayY,  @displayColor,  "Enter Price of 1x " + @name)
                    else
                        Display.new(@spacing, @spacing, @displayX, @displayY,  @displayColor,  '$' + @price)
                    end
                end
            when 37   # Period
                if @price.eql?('')
                    @price = '0.'
                    Display.new(@spacing, @spacing, @displayX, @displayY,  @displayColor, '$' + @price)
                elsif !@price.include?('.')
                    @price += '.'
                    Display.new(@spacing, @spacing, @displayX, @displayY,  @displayColor,'$' +  @price)
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
                        Display.new(@spacing, @spacing, @displayX , @displayY , @displayColor, final)
                        Display.new(@spacing, @spacing + @displayY*1, @displayX , @displayY , @displayColor, "Amount Saved: $%.2f" % [saved]) # Amount Saved 
                        Display.new(@spacing, @spacing + @displayY*2, @displayX , @displayY*2, @displayColor, "") # Items
                        Display.new(@spacing, @spacing + @displayY*4, @displayX , @displayY , @displayColor, "Subtotal: $%.2f" % [subtotal]) # Subtotal
                        Display.new(@spacing, @spacing + @displayY*5, @displayX , @displayY , @displayColor, "Total: $%.2f" % [total]) # Total
                        
                        @grandTotal = total
                        @grandSubtotal = subtotal
                        @grandSaved = saved 
    
                        temp = ShoppingItem.new(@name, @price.to_f, @quant.to_i)
                        @name = ''
                        @price = ''
                        @quant = ''
                        @itemDisplay = @itemDisplay + temp.printLabel() + ", "                
                        Display.new(@spacing, @spacing + @displayY*2, @displayX , @displayY*2, @displayColor, @itemDisplay) # Item
                    rescue => e
                        final = e.message + ', Enter correct state abbreviation'
                        Display.new(@spacing, @spacing, @displayX , @displayY , @displayColor, final)
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
                Display.new(@spacing, @spacing, @displayX , @displayY , @displayColor, "Enter State Abbreviation") # main typing display
                Display.new(@spacing, @spacing + @displayY*1, @displayX , @displayY , @displayColor, "Amount Saved: $%.2f" % [saved]) # Amount Saved 
                Display.new(@spacing, @spacing + @displayY*2, @displayX , @displayY*2 , @displayColor, "") # Items
                Display.new(@spacing, @spacing + @displayY*4, @displayX , @displayY , @displayColor, "Subtotal: $%.2f" % [subtotal]) # Subtotal
                Display.new(@spacing, @spacing + @displayY*5, @displayX , @displayY , @displayColor, "Total: $%.2f" % [total]) # Total
            when 38 # Enter to add more items
                @priceLabel = true
                @saleLabel = true
                @quantityLabel = true
                @itemLabel = true
                @price = ''
                @sale = ''
                @first = false
                Display.new(@spacing, @spacing, @displayX , @displayY , @displayColor, "Enter Sale %")
            end
        end
    end
end

click = Sound.new('mixkit-mouse-click-close-1113.wav')
click.volume = 30
cash = Sound.new('mixkit-coins-handling-1939.wav')
cash.volume = 30

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
        if x > 0 && x < (get :width) - 1 && y > 0 && y < (get :height) - 1 && buttons[i].inRect(x, y)
            buttons[i].color = 'yellow'
        else
            buttons[i].reset_color
        end
        buttons[i].draw
    end
end

show
