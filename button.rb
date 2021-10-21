# @author Rosalinda Chamale, Jack Schmid, Carl Fukawa
class Button
    @@numOfButtons = 0
    def initialize(x, y, width, height, color, label)
        @x = x
        @y = y 
        @width = width
        @height = height 
        @color = color
        @outlineWidth = 4
        @outline = Rectangle.new(
            x: @x - @outlineWidth/2, y: @y - @outlineWidth/2,
            width: @width + @outlineWidth, height: @height + @outlineWidth,
            color: 'black'
        )
        @rect = Rectangle.new(
            x: @x, y: @y,
            width: @width, height: @height,
            color: @color
        )
        @label = Text.new(
            label,
            x: x + width/2 - 6, y: y + height/2 - 15,
            size: 20,
            color: 'black'
            )
        def inRect(x, y)
            return x > @x && x < (@x + @width) && y > @y && y < (@y + @height) 
        end
        @@numOfButtons += 1
    end
end