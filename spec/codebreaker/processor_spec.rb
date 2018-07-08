#require "../lib/processor.rb"
require 'spec_helper'

describe Processor do
  context 'when testing #place_match method'do
    code = [1, 2, 3, 4]
    [
      [
        [1, 1, 1, 1], ['+', ' ', ' ', ' ']
      ],
      [
        [2, 2, 2, 2], [' ', '+', ' ', ' ']
      ],
      [
        [3, 3, 3, 3], [' ', ' ', '+', ' ']
      ],
      [
        [4, 4, 4, 4], [' ', ' ', ' ', '+']
      ],
      [
        [1, 2, 1, 1], ['+', '+', ' ', ' ']
      ],
      [
        [1, 1, 3, 1], ['+', ' ', '+', ' ']
      ],
      [
        [1, 1, 1, 4], ['+', ' ', ' ', '+']
      ],
      [
        [1, 2, 3, 1], ['+', '+', '+', ' ']
      ],
      [
        [1, 2, 1, 4], ['+', '+', ' ', '+']
      ],
      [
        [1, 2, 3, 4], ['+', '+', '+', '+']
      ],
      [
        [5, 6, 5, 6], [' ', ' ', ' ', ' ']
      ]
    ].each do |value|
      it "tests that #{value.first} equals to #{value.last}" do
        expect(subject.place_match(code, value.first)).to eq value.last
      end
    end
  end
  context 'when testing #out_of_place_match method'do
    code = [1, 2, 3, 4]
    [
      [
        [1, 1, 1, 1], ['+', ' ', ' ', ' ']
      ],
      [
        [2, 2, 2, 2], [' ', '+', ' ', ' ']
      ],
      [
        [3, 3, 3, 3], [' ', ' ', '+', ' ']
      ],
      [
        [4, 4, 4, 4], [' ', ' ', ' ', '+']
      ],
      [
        [1, 2, 1, 1], ['+', '+', ' ', ' ']
      ],
      [
        [1, 1, 3, 1], ['+', ' ', '+', ' ']
      ],
      [
        [1, 1, 1, 4], ['+', ' ', ' ', '+']
      ],
      [
        [1, 2, 3, 1], ['+', '+', '+', ' ']
      ],
      [
        [1, 2, 1, 4], ['+', '+', ' ', '+']
      ],
      [
        [1, 2, 3, 4], ['+', '+', '+', '+']
      ],
      [
        [5, 6, 5, 6], [' ', ' ', ' ', ' ']
      ]
    ].each do |value|
      it "returns '-' or leaves ' ' as is. guess : #{value[0]}, incomming result: #{value[1]} and result array: #{value.last}" do
        expect(subject.out_of_place_match(value.last, code, value.first)).to eq value.last
      end
    end
    [
      [
        [1, 1, 5, 6], ['+', ' ', ' ', ' '], ['+', '-', ' ', ' ']
      ],
      [
        [1, 3, 5, 3], ['+', ' ', ' ', ' '], ['+', '-', ' ', '-']
      ],
      [
        [1, 4, 2, 3], ['+', ' ', ' ', ' '], ['+', '-', '-', '-']
      ],
      [
        [1, 1, 3, 6], ['+', ' ', '+', ' '], ['+', '-', '+', ' ']
      ],
      [
        [1, 1, 2, 4], ['+', ' ', ' ', '+'], ['+', '-', '-', '+']
      ],
      [
        [1, 2, 3, 6], ['+', '+', '+', ' '], ['+', '+', '+', ' ']
      ],
      [
        [1, 1, 3, 3], ['+', '+', '+', ' '], ['+', '+', '+', '-']
      ],
      [
        [2, 2, 3, 4], [' ', '+', '+', '+'], ['-', '+', '+', '+']
      ]
    ].each do |value|
      it "tests that #{value.first} equals to #{value.last}" do
        expect(subject.out_of_place_match(value[1], code, value[0])).to eq value.last
      end
    end
  end
    context 'when testing #hint_processor method' do
      code = [1, 2, 3, 4]
      it 'checks if hint is displayed' do
        expect(subject).to receive(:hint_message)
        subject.hint_processor(code)
      end
  end
end
