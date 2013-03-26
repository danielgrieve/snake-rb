module Snake
  class Snake
    extend Forwardable
    def_delegators :@game, :draw_quad

    attr_reader :head, :tail, :game

    UP = [0, -10]
    DOWN = [0, 10]
    LEFT = [-10, 0]
    RIGHT = [10, 0]

    START_LOCATION = [100, 100]
    START_DIRECTION = RIGHT
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

        @game.die if tail_in_area?(@head.x, @head.y)
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

    def in_area?(x, y)
      return true if @head.x == x && @head.y == y
      tail_in_area?(x, y)
    end

    def tail_in_area?(x, y)
      @tail.each do |tail|
        return true if tail.x == x && tail.y == y
      end

      false
    end

    def button_down(id)
      if id == Gosu::KbUp && @head.last_movement != DOWN
        @head.direction = UP
      elsif id == Gosu::KbDown && @head.last_movement != UP
        @head.direction = DOWN
      elsif id == Gosu::KbLeft && @head.last_movement != RIGHT
        @head.direction = LEFT
      elsif id == Gosu::KbRight && @head.last_movement != LEFT
        @head.direction = RIGHT
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

    def move_segment(x, y)
      new_x = @x + x
      new_x = 0 if new_x >= @snake.game.width
      new_x = @snake.game.width - width if new_x < 0

      new_y = @y + y
      new_y = 0 if new_y >= @snake.game.height
      new_y = @snake.game.height - height if new_y < 0

      @x = new_x
      @y = new_y
    end
  end

  class Head < Segment
    attr_accessor :direction, :last_movement

    def initialize(snake, x, y)
      super(snake, x, y)
    end

    def move
      @last_movement = @direction
      move_segment(@direction[0], @direction[1])

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
      move_segment(direction[0], direction[1])
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
