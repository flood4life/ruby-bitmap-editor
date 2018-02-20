class BitmapCommandParser
  class << self
    def call(line)
      command, *args = *line.split(' ')
      check_arity(command, args.length)
      method = command_to_symbol(command)

    end

    private

    def command_to_symbol(command)
      case command
      when 'I'
        :new
      when 'C'
        :clear
      when 'L'
        :set
      when 'V'
        :draw_vertical_line
      when 'H'
        :draw_horizontal_line
      when 'S'
        :to_s
      else
        raise ArgumentError, "Unknown command (#{command})"
      end
    end

    def check_arity(command, actual)
      expected = command_arity(command)
      if actual != expected
        raise ArgumentError, "Expected #{expected} arguments for command #{command}, got #{actual}"
      end
    end

    def command_arity(method)
      case method
      when 'C', 'S'
        0
      when 'I'
        2
      when 'L'
        3
      when 'H', 'V'
        4
      else
        raise ArgumentError, "Unknown command (#{method})"
      end
    end
  end
end