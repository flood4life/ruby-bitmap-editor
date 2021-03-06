require 'spec_helper'
require_relative '../lib/bitmap_editor'

describe BitmapEditor do
  subject { BitmapEditor.new(width: 3, height: 4) }
  describe '#initialize' do
    describe 'when input is correct' do
      let(:biggest_editor) { BitmapEditor.new(width: 250, height: 250) }

      it 'creates an M x N image' do
        expect(subject.at(x: 3, y: 4)).to_not be_nil
        expect(subject.at(x: 4, y: 3)).to be_nil
        expect(biggest_editor.at(x: 250, y: 250)).to_not be_nil
      end
      it 'starts coordinates from 1' do
        expect(subject.at(x: 0, y: 0)).to be_nil
      end
      it 'creates a totally white (O) image' do
        expect(subject.at(x: 1, y: 1)).to eq('O')
        expect(subject.at(x: 3, y: 4)).to eq('O')
      end
    end
    describe 'when input is not correct' do
      describe 'when width or height is greater than 250' do
        let(:too_wide) { BitmapEditor.new(width: 251, height: 10) }
        let(:too_long) { BitmapEditor.new(width: 10, height: 251) }

        it 'raises an ArgumentError' do
          expect {
            too_wide
          }.to raise_error(ArgumentError, "Width (251) is greater than 250")

          expect {
            too_long
          }.to raise_error(ArgumentError, "Height (251) is greater than 250")
        end
      end

      describe 'when width or height is lower than 1' do
        let(:zero_width) { BitmapEditor.new(width: 0, height: 10) }
        let(:zero_height) { BitmapEditor.new(width: 10, height: 0) }
        let(:negative_width) { BitmapEditor.new(width: -1, height: 10) }
        let(:negative_height) { BitmapEditor.new(width: 10, height: -1) }

        it 'raises an ArgumentError' do
          expect {
            zero_width
          }.to raise_error(ArgumentError, "Width (0) is less than 1")
          expect {
            zero_height
          }.to raise_error(ArgumentError, "Height (0) is less than 1")
          expect {
            negative_width
          }.to raise_error(ArgumentError, "Width (-1) is less than 1")
          expect {
            negative_height
          }.to raise_error(ArgumentError, "Height (-1) is less than 1")
        end
      end

      describe 'when width or height are not an Integer' do
        let(:string_width) { BitmapEditor.new(width: '1', height: 1) }
        let(:string_height) { BitmapEditor.new(width: 1, height: '1') }
        let(:float_width) { BitmapEditor.new(width: 1.0, height: 1) }
        let(:float_height) { BitmapEditor.new(width: 1, height: 1.0) }

        it 'raises an ArgumentError' do
          expect {
            string_width
          }.to raise_error(ArgumentError, "Width (1:String) is not an Integer")
          expect {
            string_height
          }.to raise_error(ArgumentError, "Height (1:String) is not an Integer")
          expect {
            float_width
          }.to raise_error(ArgumentError, "Width (1.0:Float) is not an Integer")
          expect {
            float_height
          }.to raise_error(ArgumentError, "Height (1.0:Float) is not an Integer")
        end
      end

    end
  end

  describe '#clear' do
    it "resets the bitmap to all 'O's" do
      expect(subject.at(x: 1, y: 1)).to eq('O')
      subject.set(x: 1, y: 1, color: 'A')
      expect(subject.at(x: 1, y: 1)).to eq('A')
      subject.clear
      expect(subject.at(x: 1, y: 1)).to eq('O')
    end
  end

  describe '#set' do
    describe 'when input is correct' do
      it 'changes the appropriate bit' do
        expect(subject.at(x: 1, y: 1)).to eq('O')
        expect(subject.at(x: 3, y: 4)).to eq('O')
        subject.set(x: 1, y: 1, color: 'A')
        subject.set(x: 3, y: 4, color: 'Z')
        expect(subject.at(x: 1, y: 1)).to eq('A')
        expect(subject.at(x: 3, y: 4)).to eq('Z')
      end
    end

    describe 'when input is not correct' do
      describe 'when x or y is not an Integer' do
        it 'raises an ArgumentError' do
          expect {
            subject.set(x: '1', y: 1, color: 'C')
          }.to raise_error(ArgumentError, "X (1:String) is not an Integer")
          expect {
            subject.set(x: 1, y: '1', color: 'C')
          }.to raise_error(ArgumentError, "Y (1:String) is not an Integer")
        end
      end

      describe 'when x or y is not in range' do
        it 'raises an ArgumentError' do
          expect {
            subject.set(x: 0, y: 1, color: 'C')
          }.to raise_error(ArgumentError, "X (0) is less than 1")
          expect {
            subject.set(x: 1, y: 0, color: 'C')
          }.to raise_error(ArgumentError, "Y (0) is less than 1")
          expect {
            subject.set(x: 4, y: 1, color: 'C')
          }.to raise_error(ArgumentError, "X (4) is greater than 3")
          expect {
            subject.set(x: 1, y: 5, color: 'C')
          }.to raise_error(ArgumentError, "Y (5) is greater than 4")
        end
      end


      describe 'when color is not a String' do
        it 'raises an ArgumentError' do
          expect {
            subject.set(x: 1, y: 1, color: 1)
          }.to raise_error(ArgumentError, "Color (1:Fixnum) is not a String")
          expect {
            subject.set(x: 1, y: 1, color: [1])
          }.to raise_error(ArgumentError, "Color ([1]:Array) is not a String")
        end
      end

      describe 'when color is not a capital letter' do
        it 'raises an ArgumentError' do
          expect {
            subject.set(x: 1, y: 1, color: 'c')
          }.to raise_error(ArgumentError, "Color (c) is not a capital letter")
          expect {
            subject.set(x: 1, y: 1, color: '0')
          }.to raise_error(ArgumentError, "Color (0) is not a capital letter")
        end
      end

      describe 'when color contains not exactly 1 character' do
        it 'raises an ArgumentError' do
          expect {
            subject.set(x: 1, y: 1, color: '')
          }.to raise_error(ArgumentError, "Color () is not a single character")
          expect {
            subject.set(x: 1, y: 1, color: 'AB')
          }.to raise_error(ArgumentError, "Color (AB) is not a single character")
        end
      end
    end
  end

  describe '#draw_vertical_line' do
    describe 'when input is correct' do
      it 'changes color for bits in column X between rows Y1 and Y2 inclusively' do
        expect(subject.at(x: 1, y: 1)).to eq('O')
        expect(subject.at(x: 2, y: 1)).to eq('O')
        expect(subject.at(x: 1, y: 2)).to eq('O')
        expect(subject.at(x: 1, y: 3)).to eq('O')
        expect(subject.at(x: 1, y: 4)).to eq('O')
        subject.draw_vertical_line(x: 1, y1: 1, y2: 3, color: 'A')
        expect(subject.at(x: 1, y: 1)).to eq('A')
        expect(subject.at(x: 2, y: 1)).to eq('O')
        expect(subject.at(x: 1, y: 2)).to eq('A')
        expect(subject.at(x: 1, y: 3)).to eq('A')
        expect(subject.at(x: 1, y: 4)).to eq('O')
      end
    end

    describe 'when input is not correct' do
      describe 'when x, y1 or y2 is not an Integer' do
        it 'raises an ArgumentError' do
          expect {
            subject.draw_vertical_line(x: '1', y1: 1, y2: 1, color: 'A')
          }.to raise_error(ArgumentError, "X (1:String) is not an Integer")
          expect {
            subject.draw_vertical_line(x: 1, y1: '1', y2: 1, color: 'A')
          }.to raise_error(ArgumentError, "Y1 (1:String) is not an Integer")
          expect {
            subject.draw_vertical_line(x: 1, y1: 1, y2: '1', color: 'A')
          }.to raise_error(ArgumentError, "Y2 (1:String) is not an Integer")
        end
      end
      describe 'when x, y1 or y2 is not in range' do
        it 'raises an ArgumentError' do
          expect {
            subject.draw_vertical_line(x: 4, y1: 1, y2: 1, color: 'A')
          }.to raise_error(ArgumentError, "X (4) is greater than 3")
          expect {
            subject.draw_vertical_line(x: 0, y1: 1, y2: 1, color: 'A')
          }.to raise_error(ArgumentError, "X (0) is less than 1")
          expect {
            subject.draw_vertical_line(x: 1, y1: 5, y2: 5, color: 'A')
          }.to raise_error(ArgumentError, "Y1 (5) is greater than 4")
          expect {
            subject.draw_vertical_line(x: 1, y1: 4, y2: 5, color: 'A')
          }.to raise_error(ArgumentError, "Y2 (5) is greater than 4")
          expect {
            subject.draw_vertical_line(x: 1, y1: 0, y2: 1, color: 'A')
          }.to raise_error(ArgumentError, "Y1 (0) is less than 1")
        end
      end
      describe 'when y2 is less than y1' do
        it 'raises an ArgumentError' do
          expect {
            subject.draw_vertical_line(x: 1, y1: 2, y2: 1, color: 'A')
          }.to raise_error(ArgumentError, "Y2 (1) is less than Y1 (2)")
        end
      end
      describe 'when color is not a String' do
        it 'raises an ArgumentError' do
          expect {
            subject.draw_vertical_line(x: 1, y1: 2, y2: 1, color: 1)
          }.to raise_error(ArgumentError, "Color (1:Fixnum) is not a String")
          expect {
            subject.draw_vertical_line(x: 1, y1: 2, y2: 1, color: [1])
          }.to raise_error(ArgumentError, "Color ([1]:Array) is not a String")
        end
      end

      describe 'when color is not a capital letter' do
        it 'raises an ArgumentError' do
          expect {
            subject.draw_vertical_line(x: 1, y1: 2, y2: 1, color: 'c')
          }.to raise_error(ArgumentError, "Color (c) is not a capital letter")
          expect {
            subject.draw_vertical_line(x: 1, y1: 2, y2: 1, color: '0')
          }.to raise_error(ArgumentError, "Color (0) is not a capital letter")
        end
      end

      describe 'when color contains not exactly 1 character' do
        it 'raises an ArgumentError' do
          expect {
            subject.draw_vertical_line(x: 1, y1: 2, y2: 1, color: '')
          }.to raise_error(ArgumentError, "Color () is not a single character")
          expect {
            subject.draw_vertical_line(x: 1, y1: 2, y2: 1, color: 'AB')
          }.to raise_error(ArgumentError, "Color (AB) is not a single character")
        end
      end
    end
  end

  describe '#draw_horizontal_line' do
    describe 'when input is correct' do
      it 'changes color for bits in row Y between columns X1 and X2 inclusively' do
        expect(subject.at(x: 1, y: 1)).to eq('O')
        expect(subject.at(x: 2, y: 1)).to eq('O')
        expect(subject.at(x: 3, y: 1)).to eq('O')
        expect(subject.at(x: 1, y: 2)).to eq('O')
        subject.draw_horizontal_line(x1: 1, x2: 2, y: 1, color: 'A')
        expect(subject.at(x: 1, y: 1)).to eq('A')
        expect(subject.at(x: 2, y: 1)).to eq('A')
        expect(subject.at(x: 3, y: 1)).to eq('O')
        expect(subject.at(x: 1, y: 2)).to eq('O')
      end
    end

    describe 'when input is not correct' do
      describe 'when x1, x2 or y is not an Integer' do
        it 'raises an ArgumentError' do
          expect {
            subject.draw_horizontal_line(x1: '1', x2: 1, y: 1, color: 'A')
          }.to raise_error(ArgumentError, "X1 (1:String) is not an Integer")
          expect {
            subject.draw_horizontal_line(x1: 1, x2: '1', y: 1, color: 'A')
          }.to raise_error(ArgumentError, "X2 (1:String) is not an Integer")
          expect {
            subject.draw_horizontal_line(x1: 1, x2: 1, y: '1', color: 'A')
          }.to raise_error(ArgumentError, "Y (1:String) is not an Integer")
        end
      end
      describe 'when x1, x2 or y is not in range' do
        it 'raises an ArgumentError' do
          expect {
            subject.draw_horizontal_line(x1: 4, x2: 1, y: 1, color: 'A')
          }.to raise_error(ArgumentError, "X1 (4) is greater than 3")
          expect {
            subject.draw_horizontal_line(x1: 0, x2: 1, y: 1, color: 'A')
          }.to raise_error(ArgumentError, "X1 (0) is less than 1")
          expect {
            subject.draw_horizontal_line(x1: 1, x2: 4, y: 1, color: 'A')
          }.to raise_error(ArgumentError, "X2 (4) is greater than 3")
          expect {
            subject.draw_horizontal_line(x1: 1, x2: 2, y: 5, color: 'A')
          }.to raise_error(ArgumentError, "Y (5) is greater than 4")
          expect {
            subject.draw_horizontal_line(x1: 1, x2: 1, y: 0, color: 'A')
          }.to raise_error(ArgumentError, "Y (0) is less than 1")
        end
      end
      describe 'when x2 is less than x1' do
        it 'raises an ArgumentError' do
          expect {
            subject.draw_horizontal_line(x1: 2, x2: 1, y: 1, color: 'A')
          }.to raise_error(ArgumentError, "X2 (1) is less than X1 (2)")
        end
      end
      describe 'when color is not a String' do
        it 'raises an ArgumentError' do
          expect {
            subject.draw_horizontal_line(x1: 1, x2: 2, y: 1, color: 1)
          }.to raise_error(ArgumentError, "Color (1:Fixnum) is not a String")
          expect {
            subject.draw_horizontal_line(x1: 1, x2: 2, y: 1, color: [1])
          }.to raise_error(ArgumentError, "Color ([1]:Array) is not a String")
        end
      end

      describe 'when color is not a capital letter' do
        it 'raises an ArgumentError' do
          expect {
            subject.draw_horizontal_line(x1: 1, x2: 2, y: 1, color: 'c')
          }.to raise_error(ArgumentError, "Color (c) is not a capital letter")
          expect {
            subject.draw_horizontal_line(x1: 1, x2: 2, y: 1, color: '0')
          }.to raise_error(ArgumentError, "Color (0) is not a capital letter")
        end
      end

      describe 'when color contains not exactly 1 character' do
        it 'raises an ArgumentError' do
          expect {
            subject.draw_horizontal_line(x1: 1, x2: 2, y: 1, color: '')
          }.to raise_error(ArgumentError, "Color () is not a single character")
          expect {
            subject.draw_horizontal_line(x1: 1, x2: 2, y: 1, color: 'AB')
          }.to raise_error(ArgumentError, "Color (AB) is not a single character")
        end
      end
    end
  end

  describe "#to_s" do
    it 'shows a correct string representation of the bitmap' do
      clean_3_by_4 = <<-map
O O O
O O O
O O O
O O O
      map
      expect(subject.to_s).to eq(clean_3_by_4)

      first_column_a = <<-map
A O O
A O O
A O O
A O O
      map
      subject.draw_vertical_line(x: 1, y1: 1, y2: 4, color: 'A')
      expect(subject.to_s).to eq(first_column_a)

      first_row_b = <<-map
B B B
A O O
A O O
A O O
      map
      subject.draw_horizontal_line(x1: 1, x2: 3, y: 1, color: 'B')
      expect(subject.to_s).to eq(first_row_b)
    end
  end
end