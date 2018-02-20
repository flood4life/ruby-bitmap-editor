class BitmapEditor
  def initialize(width:, height:)
    check_argument_type('height', height)
    check_argument_type('width', width)

  end

  private

  def check_argument_type(name, value)
    unless value.is_a?(Integer)
      raise ArgumentError, "#{name.capitalize} (#{value}:#{value.class}) is not an Integer"
    end
  end
end
