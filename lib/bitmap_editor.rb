class BitmapEditor
  VALUE_RANGE = (1..250)

  def initialize(width:, height:)
    check_argument_type('height', height)
    check_argument_type('width', width)
    check_argument_value('height', height, VALUE_RANGE)
    check_argument_value('width', width, VALUE_RANGE)

  end

  private

  def check_argument_type(name, value)
    unless value.is_a?(Integer)
      raise ArgumentError, "#{name.capitalize} (#{value}:#{value.class}) is not an Integer"
    end
  end

  def check_argument_value(name, value, range)
    if value < range.first
      raise ArgumentError, value_error_message(name, value, range.first, 'lower')
    elsif value > range.last
      raise ArgumentError, value_error_message(name, value, range.last, 'bigger')
    end
  end

  def value_error_message(name, value, boundary, relation)
    "#{name.capitalize} (#{value}) is #{relation} than #{boundary}"
  end
end
