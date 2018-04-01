# allows reading in the "map.png" to build the level
require "stumpy_png"

class Level
    @solid : Tile
    @top   : Tile
    @right : Tile
    @left  : Tile
    @level : Array(Array(Tile | Nil))
    @game  : World
    property tilewidth : Float64

    def initialize(@game, @name = "def")
        @tilewidth = 25.0
        @solid = tile(0)
        @top   = tile(1)
        @right = tile(2)
        @left  = tile(3)
        @level = buildlevel
    end

  # return the level built from the map.png in the correct level file.
    def buildlevel()
        canvas = StumpyPNG.read("resources/levels/"+@name+"/map.png")
        canvas.width.times.map do |x|
            canvas.height.times.map do |y|
                r,g,b = canvas[x,y].to_rgb8
                if [255, 0, 0] == [r, g, b]
                    Tile.new(@solid)
                else
                    nil
                end
            end.to_a
        end.to_a
    end

    def to_tile_coord(x)
        (x / @tilewidth).to_i - (x < 0 ? 1 : 0)
    end

    def tile_at?(x,y)
      return (0 <= x < @level.size) && (0 <= y < @level[0].size) && !@level[x][y].nil?
    end

  # do the coordinates given clip? (are they inside a block)
    def clips(x : Number, y : Number) : Bool
        tilex = to_tile_coord(x)
        tiley = to_tile_coord(y)
        return !tile_at?(tilex,tiley)
    end

  # the same as clips(Num,Num) except this takes a rectangle of points
    def clips(xa : Number, ya : Number, xb : Number, yb : Number) : Bool
        yrange = (to_tile_coord(ya) .. to_tile_coord(yb))
        (to_tile_coord(xa) .. to_tile_coord(xb)).each do |x|
            yrange.each do |y|
                return true unless !tile_at?(x,y)
            end
        end
        return false
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
                tile.draw @game
            end
        end
    end
end

# A class to represent a single block on the map/level
class Tile
    property sprite : SF::Sprite,
             size   : Float64 
    def initialize(sprite : String, @size)
        @sprite = Entity.get_sprite(sprite)
        scale = @size / @sprite.texture_rect.width
        @sprite.scale = SF.vector2(scale, scale)
    end

    def initialize(tile : Tile)
      @size = tile.size 
      @sprite = SF::Sprite.new(tile.sprite.texture.as(SF::Texture))
      @sprite.scale = tile.sprite.scale
    end

    def draw(game)
      scale = @size / @sprite.texture_rect.width
      @sprite.scale = {scale, scale}
      game.drawsprite @sprite
    end
end
