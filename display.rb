# @author Rosalinda Chamale, Jack Schmid
class Display
    @@numOfDisplays = 0
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
            x: x + 6, y: y + height/2 - 15,
            size: 20,
            color: 'black'
            )
        @@numOfDisplays += 1
    end
end 
