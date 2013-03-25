module Snake
  class Snake
    extend Forwardable
    def_delegators :@game, :draw_quad

    def initialize(game)
      @game = game
      @last_moved = 0

      @head = Head.new(self, 100, 100)
    end

    def update
      move_time = Gosu::milliseconds
      if @last_moved + 500 < move_time
        @head.move

        @last_moved = move_time
      end
    end

    def draw
      @head.draw
    end

    def button_down(id)
      if id == Gosu::KbUp
        @head.move_up
      elsif id == Gosu::KbDown
        @head.move_down
      elsif id == Gosu::KbRight
        @head.move_right
      elsif id == Gosu::KbLeft
        @head.move_left
      end
    end
  end

  class Segment
    extend Forwardable
    def_delegators :@snake, :draw_quad

    attr_accessor :x, :y, :width, :height, :direction

    def initialize(snake, x, y)
      @snake = snake
      @x = x
      @y = y
      @width = 10
      @height = 10

      @direction = [10, 0]
    end

    def draw
      draw_quad(
        x,          y,           Gosu::Color::BLACK,
        x + width,  y,           Gosu::Color::BLACK,
        x,          y + height,  Gosu::Color::BLACK,
        x + width,  y + height,  Gosu::Color::BLACK
      )
    end
  end

  class Head < Segment
    def move
      @x += @direction[0]
      @y += @direction[1]
    end

    def move_down
      @direction = [0, 10]
    end

    def move_left
      @direction = [-10, 0]
    end

    def move_right
      @direction = [10, 0]
    end

    def move_up
      @direction = [0, -10]
    end
  end
end
