class BitmapEditor
  VALUE_RANGE = (1..250)

  attr_reader :width, :width_range, :height, :height_range

  def initialize(width:, height:)
    check_argument_type('height', height)
    check_argument_type('width', width)
    check_argument_value('height', height, VALUE_RANGE)
    check_argument_value('width', width, VALUE_RANGE)

    @height = height
    @width  = width

    @height_range = (1..height)
    @width_range  = (1..width)

    @bitmap = Array.new(width) { Array.new(height, 'O') }
  end

  def at(x:, y:)
    if width_range.cover?(x) && height_range.cover?(y)
      @bitmap[x - 1][y - 1]
    else
      nil
    end
  end

  private

  def check_argument_type(name, value)
    unless value.is_a?(Integer)
      raise ArgumentError, "#{name.capitalize} (#{value}:#{value.class}) is not an Integer"
    end
  end

  def check_argument_value(name, value, range)
    if value < range.first
      raise ArgumentError, value_error_message(name, value, range.first, 'less')
    elsif value > range.last
      raise ArgumentError, value_error_message(name, value, range.last, 'greater')
    end
  end

  def value_error_message(name, value, boundary, relation)
    "#{name.capitalize} (#{value}) is #{relation} than #{boundary}"
  end
end
