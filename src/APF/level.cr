# allows reading in the "map.png" to build the level
require "stumpy_png"

class Level
    @solid : Tile
    @top   : Tile
    @right : Tile
    @left  : Tile  
    @level : Array(Array(Tile | Nil))
    @game : Game

    def initialize(@game, @name = "def")
        @tilewidth = 20.0

        @solid = tile(0)
        @top   = tile(1)
        @right = tile(2)
        @left  = tile(3)
        @level = buildlevel
    end

    # return the level built from the map.png in the correct level file.
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
   
    # do the coordinates given clip? (are they inside a block) 
    def clips(x : Number, y : Number) : Boolean
        !@level[x.to_i/@tilewidth][y.to_i/@tilewidth].nil?
    end

    # get the tile requested as a Tile
    def tile(x)
        Tile.new("levels/"+@name+"/"+x.to_s, @tilewidth)
    end

    # draw the level
    def draw
        return if @game.nil?
        @level.each_with_index do |row,x|
            row.each_with_index do |tile,y|  
                next if tile.nil?
                tile.sprite.position = SF.vector2(x * @tilewidth, y * @tilewidth)
                @game.drawsprite tile.sprite       
            end
        end
    end
end 

# A class to represent a single block on the map/level
class Tile
    property sprite : SF::Sprite
    def initialize(sprite : String, size : Float) 
        @sprite = Entity.get_sprite(sprite)
        scale = size / @sprite.texture_rect.width
        @sprite.scale = SF.vector2(scale, scale)
    end
end
