#require "../lib/game.rb"
#require "../lib/processor.rb"
require 'spec_helper'
describe Game do

  context 'when testing #generator method' do
    it 'checks that number matches a regex template' do
      expect(subject.generator.join).to match(/^[1-6]{4}$/)
    end

    it 'returns array of integers' do
      aray = subject.generator
      integers_array = aray.select { |x| x.is_a? Integer }
      expect(aray).to eq integers_array
    end
  end

  context 'When testing #attempts method' do
    it 'decreases attempts by 1 when used' do
      expect_any_instance_of(Processor).to receive(:attempts_left)
      subject.attempts
    end
  end

  context 'when testing #check_hint mehod' do
    it 'returns no_hint_message when hint was used before' do
      subject.instance_variable_set(:@hint_available, false)
      expect(subject).to receive(:have_no_hints_message)
      subject.check_hint
    end
  end

  context 'when testing #new_game method' do
    it 'tests new_game process' do
      expect(subject).to receive(:loop).and_yield
#     allow(subject).to receive(:gets).and_return('1234')
      expect(subject).to receive(:choice_processor).once
      expect(subject).to receive(:attempts).once
      expect(subject).to receive(:win).once
      expect(subject).to receive(:lost).once
      subject.new_game
    end
  end
  context 'when testing #hint_processor' do
    it 'calls hint_processor method when hint is available' do
      subject.instance_variable_set(:@hint_avaliable, true)
      expect_any_instance_of(Processor).to receive(:hint_processor).and_return([1, 2, 3, 4])
      subject.check_hint
    end
  end
  
  context 'when testing #choice_processor method' do
    it 'calls #turn_processor' do
      allow(subject).to receive(:gets).and_return('1234')
      expect_any_instance_of(Processor).to receive(:turn_processor)
      subject.choice_processor
    end

    it 'calls #end_game method' do
      allow(subject).to receive(:gets).and_return('q')
      expect(subject).to receive(:end_game)
      subject.choice_processor
    end

    it 'calls #check_hint' do
      allow(subject).to receive(:gets).and_return('h')
      expect(subject).to receive(:check_hint)
      subject.choice_processor
    end
  end
end
