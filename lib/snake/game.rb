module Snake
  class Game
    extend Forwardable

    def_delegators :@window, :draw_quad, :width, :height

    attr_reader :food

    def initialize(window)
      @window = window

      @background_color = Gosu::Color.new(255, 185, 195, 165)

      @player = Snake.new(self)

      place_food
    end

    def update
      @player.update
    end

    def draw
      # Background
      draw_quad(
        0,      0,       Gosu::Color::GRAY,
        width,  0,       Gosu::Color::GRAY,
        0,      height,  Gosu::Color::GRAY,
        width,  height,  Gosu::Color::GRAY
      )

      draw_quad(
        @food[0], @food[1], Gosu::Color::BLUE,
        @food[0] + 10, @food[1], Gosu::Color::BLUE,
        @food[0], @food[1] + 10, Gosu::Color::BLUE,
        @food[0] + 10, @food[1] + 10, Gosu::Color::BLUE,
      )

      @player.draw
    end

    def eat_food
      @player.grow
      place_food
    end

    def place_food
      @food = nil

      while(!@food) do
        random_x = Gosu::random(10, width).ceil
        random_y = Gosu::random(10, height).ceil

        # round down to nearest 10
        random_x = random_x - (random_x % 10) if random_x % 10 != 0
        random_y = random_y - (random_y % 10) if random_y % 10 != 0

        unless snake_in_area?(random_x, random_y)
          @food = [random_x, random_y]
        end
      end
    end

    def snake_in_area?(x, y)
      head = @player.head
      return true if head.x == x && head.y == y

      @player.tail.each do |tail|
        return true if tail.x == x && tail.y == y
      end

      false
    end

    def button_down(id)
      @player.button_down(id)
    end
  end
end
