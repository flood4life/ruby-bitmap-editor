class BitmapCommandParser
  class << self
    def call(line)
      command, *args = *line.split(' ')
      check_arity(command, args.length)
      method = command_to_symbol(command)
      {
        method: method,
        arguments: arguments_hash_from_array(method, args)
      }
    end

    private

    def arguments_hash_from_array(method, args)
      case method
      when :to_s, :clear
        nil
      when :new
        { width: args[0].to_i, height: args[1].to_i }
      when :set
        { x: args[0].to_i, y: args[1].to_i, color: args[2] }
      when :draw_vertical_line
        { x: args[0].to_i, y1: args[1].to_i, y2: args[2].to_i, color: args[3] }
      when :draw_horizontal_line
        { x1: args[0].to_i, x2: args[1].to_i, y: args[2].to_i, color: args[3] }
      else
        raise ArgumentError, "Unknown method :#{method}"
      end
    end

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