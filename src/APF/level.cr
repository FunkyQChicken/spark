require "stumpy_png"

class Level
    @solid : Tile
    @top   : Tile
    @right : Tile
    @left  : Tile  
    @level : Array(Array(Tile | Nil))
    @game : Game

    def initialize(@game, @name = "def")
        @solid = tile(0)
        @top   = tile(1)
        @right = tile(2)
        @left  = tile(3)
        @level = buildlevel
    end

    def buildlevel()
        canvas = StumpyPNG.read("recources/levels/"+@name+"/map.png")
        canvas.width.times.map do |x|
            canvas.height.times.map do |y|
                r,g,b = canvas[x,y].to_rgb8
                if [255, 0, 0] == [r, g, b]
                    @solid.dup
                else
                    nil
                end
            end.to_a
        end.to_a
    end

    def tile(x)
        Tile.new("levels/"+@name+"/"+x.to_s)
    end

    def draw
        return if @game.nil?
        @level.each_with_index do |row,x|
            row.each_with_index do |tile,y|  
                next if tile.nil?
                tile.sprite.position = SF.vector2(x * 10, y * 10)
                @game.drawsprite tile.sprite       
            end
        end
    end
end 

class Tile
    property sprite : SF::Sprite
    def initialize(sprite : String) 
        @sprite = Entity.get_sprite(sprite)
        @sprite.scale = SF.vector2(10,10)
    end
end
