module Snake
  class Snake
    extend Forwardable
    def_delegators :@game, :draw_quad

    attr_reader :head, :tail

    START_LOCATION = [100, 100]
    START_DIRECTION = [10, 0]
    START_LENGTH = 3
    SPEED = 200

    def initialize(game)
      @game = game
      @last_moved = 0

      @head = Head.new(self, START_LOCATION[0], START_LOCATION[1])
      @head.direction = START_DIRECTION

      @tail = []

      (1..START_LENGTH).each do |num|
        tail = Tail.new(self, START_LOCATION[0] - num*@head.width, START_LOCATION[1])
        num.times { tail.queue << START_DIRECTION }
        @tail << tail
      end
    end

    def update
      move_time = Gosu::milliseconds
      if @last_moved + SPEED < move_time
        @head.move
        @tail.each do |tail|
          tail.move
        end

        @game.eat_food if [@head.x, @head.y] == @game.food

        @last_moved = move_time
      end
    end

    def draw
      @head.draw
      @tail.each do |tail|
        tail.draw
      end
    end

    def grow
      new_growth = @tail.last.dup
      new_growth.queue << [0, 0]
      @tail << new_growth
    end

    def button_down(id)
      if id == Gosu::KbUp
        @head.direction = [0, -10]
      elsif id == Gosu::KbDown
        @head.direction = [0, 10]
      elsif id == Gosu::KbRight
        @head.direction = [10, 0]
      elsif id == Gosu::KbLeft
        @head.direction = [-10, 0]
      end
    end
  end

  class Segment
    extend Forwardable
    def_delegators :@snake, :draw_quad

    attr_accessor :x, :y, :width, :height

    def initialize(snake, x, y)
      @snake = snake
      @x = x
      @y = y
      @width = 10
      @height = 10
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
    attr_accessor :direction

    def initialize(snake, x, y)
      super(snake, x, y)
    end

    def move
      @x += @direction[0]
      @y += @direction[1]

      @snake.tail.each do |tail|
        tail.queue << @direction
      end
    end
  end

  class Tail < Segment
    attr_accessor :queue

    def initialize(snake, x, y)
      super(snake, x, y)
      @queue = []
    end

    def move
      direction = @queue.shift

      @x += direction[0]
      @y += direction[1]
    end

    def dup
      dup_tail = Tail.new(@snake, x, y)
      queue.each do |queue|
        dup_tail.queue << queue
      end
      dup_tail
    end
  end
end
