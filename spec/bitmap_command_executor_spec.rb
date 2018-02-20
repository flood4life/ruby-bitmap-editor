require 'spec_helper'
require_relative '../lib/bitmap_command_executor'

describe BitmapCommandExecutor do
  subject { BitmapCommandExecutor.new }
  describe "#call" do
    it 'requires :new call first' do
      expect {
        subject.call(method: :set)
      }.to raise_error(StandardError, "Bitmap is not initialized")
    end

    it 'creates a bitmap when :new is called' do
      subject.call(method: :new, arguments: { width: 2, height: 2 })
      expect(subject.editor).to_not be_nil
    end

    it 'replaces the bitmap if :new is called again' do
      subject.call(method: :new, arguments: { width: 2, height: 2 })
      old_editor = subject.editor
      subject.call(method: :new, arguments: { width: 2, height: 2 })
      expect(subject.editor).to_not be(old_editor)
    end

    it 'outputs bitmap to the screen when :to_s is called' do
      subject.call(method: :new, arguments: { width: 2, height: 2 })
      expected = <<-map
O O
O O
      map
      expect {
        subject.call(method: :to_s)
      }.to output(expected).to_stdout
    end

    it 'forwards :set, :clear, :draw_vertical_line and :draw_horizontal_line to the editor' do
      subject.call(method: :new, arguments: { width: 2, height: 2 })
      editor = subject.editor
      allow(editor).to receive(:clear).and_call_original
      allow(editor).to receive(:set).and_call_original
      allow(editor).to receive(:draw_vertical_line).and_call_original
      allow(editor).to receive(:draw_horizontal_line).and_call_original

      subject.call(method: :clear)
      subject.call(method: :set, arguments: { x: 1, y: 1, color: 'A' })
      subject.call(method: :draw_vertical_line, arguments: { x: 1, y1: 1, y2: 1, color: 'A' })
      subject.call(method: :draw_horizontal_line, arguments: { x1: 1, x2: 1, y: 1, color: 'A' })

      expect(editor).to have_received(:clear)
      expect(editor).to have_received(:set).with(x: 1, y: 1, color: 'A')
      expect(editor).to have_received(:draw_vertical_line).with(x: 1, y1: 1, y2: 1, color: 'A')
      expect(editor).to have_received(:draw_horizontal_line).with(x1: 1, x2: 1, y: 1, color: 'A')
    end
  end
end