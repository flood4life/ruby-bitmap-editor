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

  describe '#set' do
    describe 'when input is correct' do
      it 'changes the appropriate bit' do
        expect(subject.at(x: 1, y: 1)).to eq('O')
        expect(subject.at(x: 3, y: 4)).to eq('O')
        subject.set(x: 1, y: 1, color: 'C')
        subject.set(x: 3, y: 4, color: 'L')
        expect(subject.at(x: 1, y: 1)).to eq('C')
        expect(subject.at(x: 3, y: 4)).to eq('L')
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
    end
  end

end