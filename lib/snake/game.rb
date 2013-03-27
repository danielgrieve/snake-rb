module Snake
  class Game
    extend Forwardable
    def_delegators :@window, :draw_quad, :width, :height, :background_color, :text_color

    attr_reader :food, :speed

    def initialize(window, speed)
      @window = window
      @speed = speed

      @background_color = Gosu::Color.new(255, 185, 195, 165)

      @player = Snake.new(self)

      @score_font = Gosu::Font.new(@window, 'media/visitor.ttf', 16)

      reset
    end

    def update
      @player.update unless @dead
    end

    def draw
      draw_background

      draw_score
      draw_food

      @player.draw

      draw_dead if @dead
    end

    def eat_food
      @score += 10
      @player.grow
      place_food
    end

    def die
      @dead = true
    end

    def button_down(id)
      reset if @dead && id == Gosu::KbReturn
      @player.button_down(id)
    end

    private
    def draw_background
      draw_quad(
        0,      0,       background_color,
        width,  0,       background_color,
        0,      height,  background_color,
        width,  height,  background_color
      )
    end

    def draw_score
      @score_font.draw(@score, 5, 5, 0, 1, 1, text_color)
    end

    def draw_food
      @food_image ||= Gosu::Image.new(@window, 'media/cherry.png', false, 0, 0, 10, 10)
      @food_image.draw(@food[0], @food[1], 1)
    end

    def draw_dead
      dead_bg_color = background_color.dup
      dead_bg_color.alpha = 200
      draw_quad(
        0,      0,       dead_bg_color,
        width,  0,       dead_bg_color,
        0,      height,  dead_bg_color,
        width,  height,  dead_bg_color,
        2
      )

      dead_font = Gosu::Font.new(@window, 'media/visitor.ttf', 20)
      message = "Oops, you're dead!"
      dead_font.draw(message,
                     (width / 2) - (dead_font.text_width(message) / 2),
                     (height / 2) - dead_font.height, 3, 1, 1, text_color)

      dead_help_font = Gosu::Font.new(@window, 'media/visitor.ttf', 14)

      message = "Q to quit"
      dead_help_font.draw(message,
                     (width / 2) - (dead_help_font.text_width(message) / 2),
                     (height / 2) - dead_font.height + 30, 3, 1, 1, text_color)

      message = "Return to start again"
      dead_help_font.draw(message,
                     (width / 2) - (dead_help_font.text_width(message) / 2),
                     (height / 2) - dead_font.height + 50, 3, 1, 1, text_color)
    end

    def place_food
      @food = nil

      while(!@food) do
        random_x = Gosu::random(10, width).ceil
        random_y = Gosu::random(10, height).ceil

        # round down to nearest 10
        random_x = random_x - (random_x % 10) if random_x % 10 != 0
        random_y = random_y - (random_y % 10) if random_y % 10 != 0

        unless @player.in_area?(random_x, random_y)
          @food = [random_x, random_y]
        end
      end
    end

    def reset
      @score = 0
      @dead = false
      place_food
      @player.reset
    end
  end
end
