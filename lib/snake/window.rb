module Snake
  class Window < Gosu::Window
    def initialize
      super(200, 200, false)
      self.caption = 'Snake'

      @menu = Menu.new(self)
    end

    def update
      @menu.update if @menu
      @game.update if @game
    end

    def draw
      @menu.draw if @menu
      @game.draw if @game
    end

    def button_down(id)
      close if id == Gosu::KbQ
      @menu.button_down(id) if @menu
      @game.button_down(id) if @game
    end

    def start(speed)
      @game = Game.new(self, speed)
      @menu = nil
    end

    def background_color
      @background_color ||= Gosu::Color.new(255, 125, 135, 110)
    end

    def text_color
      @text_color ||= Gosu::Color.from_hsv(65, 0.75, 0.15)
    end
  end
end
