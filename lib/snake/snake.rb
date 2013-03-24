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

      @direction = :right

      @last_move = 0
    end

    def update
      move_time = Gosu::milliseconds
      if @last_move + 500 < move_time
        @blocks.each { |block| block.x += block.width }
        @last_move = move_time
      end
    end

    def draw
      @blocks.each do |block|
        draw_quad(
          block.x, block.y, Gosu::Color::BLACK,
          block.x + block.width, block.y, Gosu::Color::BLACK,
          block.x, block.y + block.height, Gosu::Color::BLACK,
          block.x + block.width, block.y + block.height, Gosu::Color::BLACK
        )
      end
    end

    def button_down(id)
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
  end
end
