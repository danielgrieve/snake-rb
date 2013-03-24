module Snake
  class Window < Gosu::Window
    def initialize
      super(640, 480, false)
      self.caption = 'Snake'

      @game = Game.new(self)
    end

    def update
      @game.update
    end

    def draw
      @game.draw
    end

    def button_down(id)
      @game.button_down(id)
    end
  end
end
