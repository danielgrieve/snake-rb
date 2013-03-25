module Snake
  class Snake
    extend Forwardable

    def_delegators :@game, :draw_quad

    def initialize(game)
      @game = game

      @blocks = []
      @blocks << Block.new(50, 50)
      @blocks << Block.new(60, 50)
      @blocks << Block.new(70, 50)

      @last_moved = 0
    end

    def update
      move_time = Gosu::milliseconds
      if @last_moved + 500 < move_time
        @blocks.each do |block|
          block.move
        end
        @last_moved = move_time
      end
    end

    def draw
      @blocks.each do |block|
        block.draw(self)
      end
    end

    def button_down(id)
      if id == Gosu::KbUp
      elsif id == Gosu::KbDown
      elsif id == Gosu::KbRight
      elsif id == Gosu::KbLeft
      end
    end
  end

  class Block
    attr_accessor :x, :y, :width, :height

    def initialize(x, y)
      self.x = x
      self.y = y
      self.width = 10
      self.height = 10
    end

    def draw(game)
      game.draw_quad(
        x,          y,           Gosu::Color::BLACK,
        x + width,  y,           Gosu::Color::BLACK,
        x,          y + height,  Gosu::Color::BLACK,
        x + width,  y + height,  Gosu::Color::BLACK
      )
    end

    def move
      self.x += width
    end
  end
end
