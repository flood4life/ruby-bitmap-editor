require 'indefinite_article'

class BitmapEditor
  VALUE_RANGE = (1..250)
  COLOR_RANGE = ('A'..'Z')

  attr_reader :width, :width_range, :height, :height_range

  def initialize(width:, height:)
    check_argument_type('height', height, Integer)
    check_argument_type('width', width, Integer)
    check_argument_value('height', height, VALUE_RANGE)
    check_argument_value('width', width, VALUE_RANGE)

    @height = height
    @width  = width

    @height_range = (1..height)
    @width_range  = (1..width)

    @bitmap = new_bitmap(width: width, height: height)
  end

  def at(x:, y:)
    if width_range.cover?(x) && height_range.cover?(y)
      @bitmap[x - 1][y - 1]
    else
      nil
    end
  end

  def set(x:, y:, color:)
    check_argument_type('x', x, Integer)
    check_argument_type('y', y, Integer)
    check_argument_type('color', color, String)
    check_argument_value('x', x, width_range)
    check_argument_value('y', y, height_range)
    check_color_value(color, COLOR_RANGE)
    @bitmap[x - 1][y - 1] = color
  end

  def clear
    @bitmap = new_bitmap(width: width, height: height)
  end

  private

  def new_bitmap(width:, height:)
    Array.new(width) { Array.new(height, 'O') }
  end

  def check_argument_type(name, value, klass)
    unless value.is_a?(klass)
      raise ArgumentError, "#{name.capitalize} (#{value}:#{value.class}) is not #{klass.to_s.indefinitize}"
    end
  end

  def check_argument_value(name, value, range)
    if value < range.first
      raise ArgumentError, value_error_message(name, value, range.first, 'less')
    elsif value > range.last
      raise ArgumentError, value_error_message(name, value, range.last, 'greater')
    end
  end

  def check_color_value(value, range)
    if value.length != 1
      raise ArgumentError, "Color (#{value}) is not a single character"
    elsif !range.include?(value)
      raise ArgumentError, "Color (#{value}) is not a capital letter"
    end
  end

  def value_error_message(name, value, boundary, relation)
    "#{name.capitalize} (#{value}) is #{relation} than #{boundary}"
  end
end
