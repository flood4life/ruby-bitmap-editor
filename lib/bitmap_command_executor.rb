require_relative './bitmap_editor'

class BitmapCommandExecutor
  attr_reader :editor

  def call(method:, arguments: nil)
    if method != :new && @editor.nil?
      raise StandardError, "Bitmap is not initialized"
    end
    case method
    when :new
      @editor = BitmapEditor.new(arguments)
    when :to_s
      puts editor.to_s
    when :clear
      editor.clear
    when :set, :draw_vertical_line, :draw_horizontal_line
      editor.send(method, **arguments)
    else
      raise ArgumentError, "Unknown method :#{method}"
    end
  end
end