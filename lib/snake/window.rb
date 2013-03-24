module Snake
  class Window < Gosu::Window
    def initialize
      super(640, 480, false)
      self.caption = 'Snake'
    end
  end
end
