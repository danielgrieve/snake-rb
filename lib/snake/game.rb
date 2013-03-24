module Snake
  class Game
    extend Forwardable

    def_delegators :@window, :draw_quad, :width, :height

    def initialize(window)
      @window = window

      @background_color = Gosu::Color.new(255, 185, 195, 165)

      @player = Snake.new(self)
    end

    def update
      @player.update
    end

    def draw
      # Background
      draw_quad(
        0, 0, Gosu::Color::GRAY,
        width, 0, Gosu::Color::GRAY,
        0, height, Gosu::Color::GRAY,
        width, height, Gosu::Color::GRAY
      )

      @player.draw
    end

    def button_down(id)
    end
  end
end
