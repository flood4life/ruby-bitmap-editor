require 'spec_helper'
require_relative '../lib/bitmap_command_parser'

describe BitmapCommandParser do
  describe 'self.call' do
    it 'raises an ArgumentError if command letter is unknown' do
      expect {
        BitmapCommandParser.call('A')
      }.to raise_error(ArgumentError, "Unknown command (A)")
    end

    it 'raises an ArgumentError is the number of command arguments is wrong' do
      expect {
        BitmapCommandParser.call('I 5')
      }.to raise_error(ArgumentError, "Expected 2 arguments for command I, got 1")
      expect {
        BitmapCommandParser.call('C 5')
      }.to raise_error(ArgumentError, "Expected 0 arguments for command C, got 1")
      expect {
        BitmapCommandParser.call('L 5')
      }.to raise_error(ArgumentError, "Expected 3 arguments for command L, got 1")
      expect {
        BitmapCommandParser.call('V 5')
      }.to raise_error(ArgumentError, "Expected 4 arguments for command V, got 1")
      expect {
        BitmapCommandParser.call('H 5')
      }.to raise_error(ArgumentError, "Expected 4 arguments for command H, got 1")
      expect {
        BitmapCommandParser.call('S 5')
      }.to raise_error(ArgumentError, "Expected 0 arguments for command S, got 1")
    end

    it 'transforms a single line into a method name and a hash of arguments' do
      init = {
        method:    :new,
        arguments: {
          width:  5,
          height: 6
        }
      }
      expect(BitmapCommandParser.call('I 5 6')).to eq(init)

      clear = {
        method: :clear,
        arguments: nil
      }
      expect(BitmapCommandParser.call('C')).to eq(clear)

      set = {
        method:    :set,
        arguments: {
          x:     1,
          y:     3,
          color: 'A'
        }
      }
      expect(BitmapCommandParser.call('L 1 3 A')).to eq(set)

      vertical = {
        method: :draw_vertical_line,
        arguments: {
          x: 2,
          y1: 3,
          y2: 6,
          color: 'W'
        }
      }
      expect(BitmapCommandParser.call('V 2 3 6 W')).to eq(vertical)

      horizontal = {
        method: :draw_horizontal_line,
        arguments: {
          x1: 3,
          x2: 5,
          y: 2,
          color: 'Z'
        }
      }
      expect(BitmapCommandParser.call('H 3 5 2 Z')).to eq(horizontal)

      show = {
        method: :to_s,
        arguments: nil
      }
      expect(BitmapCommandParser.call('S')).to eq(show)
    end
  end
end