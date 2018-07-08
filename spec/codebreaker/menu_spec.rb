#require "../lib/menu.rb"
#require "../lib/game.rb"
require "spec_helper.rb"

describe Menu do
  context 'when testing #start_game method' do
    it 'returns @game.new_game' do
      expect_any_instance_of(Game).to receive :new_game
      subject.start_game
    end
  end
  context 'when testing #game_menu method' do
    it 'calls choice_processor method to process command' do
      expect(subject).to receive(:loop).and_yield
      allow(subject).to receive(:gets).and_return('p')
      expect(subject).to receive(:choice_processor).once
      expect(subject).to receive(:main_menu_message)
      subject.game_menu
    end
  end
  context 'when testing #choice_processor method' do
    it 'calls #start_game method' do
      expect(subject).to receive(:start_game)
      subject.choice_processor('p')
    end

    it 'calls #read_results method' do
      expect(subject).to receive(:read_results)
      subject.choice_processor('r')
    end

    it 'calls #end_game method' do
      expect(subject).to receive(:end_game)
      subject.choice_processor('q')
    end
  end
end
