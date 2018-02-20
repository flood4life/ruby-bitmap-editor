require 'spec_helper'
require_relative '../lib/bitmap_command_parser'

describe BitmapCommandParser do
  describe 'self.call' do
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
        method: :clear
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
        method: :to_s
      }
      expect(BitmapCommandParser.call('S')).to eq(show)
    end
  end
end