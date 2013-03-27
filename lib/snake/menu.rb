module Snake
  class Menu
    extend Forwardable

    def_delegators :@window, :draw_quad, :width, :height, :background_color, :text_color

    def initialize(window)
      @window = window

      @text = Gosu::Image.from_text(@window, 'SNAKE', 'media/visitor.ttf', 50,
                                    30, @window.width, :center)

      @option_font = Gosu::Font.new(@window, 'media/visitor.ttf', 16)
      @options = [
        { label: 'Slow',    speed: 300,  selected: false },
        { label: 'Normal',  speed: 150,  selected: true },
        { label: 'Fast',    speed: 50,  selected: false }
      ]
    end

    def update
    end

    def draw
      draw_quad(
        0,      0,       background_color,
        width,  0,       background_color,
        0,      height,  background_color,
        width,  height,  background_color
      )

      @text.draw((width / 2) - (@text.width / 2), 10, 1, 1, 1, text_color)

      draw_options(55)
    end

    def draw_options(prev_y)
      @options.each do |option|
        option_width = @option_font.text_width(option[:label])
        prev_y = prev_y + @option_font.height + 15
        option_x = (width / 2) - (option_width / 2)
        @option_font.draw(option[:label], option_x, prev_y, 1, 1, 1, text_color)

        if option[:selected]
          draw_quad(
            option_x, prev_y + @option_font.height + 3, text_color,
            option_x + option_width, prev_y + @option_font.height + 3, text_color,
            option_x, prev_y + @option_font.height + 6, text_color,
            option_x + option_width, prev_y + @option_font.height + 6, text_color
          )
        end
      end
    end

    def button_down(id)
      selected_option =  @options.find { |opt| opt[:selected] }
      selected_option_index =  @options.index(selected_option)

      if id == Gosu::KbUp && selected_option != @options.first
        @options[selected_option_index][:selected] = false
        @options[selected_option_index-1][:selected] = true
      elsif id == Gosu::KbDown && selected_option != @options.last
        @options[selected_option_index][:selected] = false
        @options[selected_option_index+1][:selected] = true
      elsif id == Gosu::KbReturn
        selected_option =  @options.find { |opt| opt[:selected] }
        @window.start(selected_option[:speed])
      end
    end
  end
end
