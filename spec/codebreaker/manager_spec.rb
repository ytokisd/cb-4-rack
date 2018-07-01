require 'spec_helper'

module Codebreaker
  RSpec.describe Manager do
    describe '#main_menu' do
      context 'when user chooses "New game"' do
        it do
          allow(subject).to receive(:gets).and_return(Manager::NEW_GAME.to_s)
          expect(subject.main_menu).to eq(Manager::NEW_GAME)
        end
      end

      context 'when user chooses "Load saved results"' do
        it do
          allow(subject).to receive(:gets).and_return(Manager::LOAD_SAVED.to_s)
          expect(subject.main_menu).to eq(Manager::LOAD_SAVED)
        end
      end

      context 'when user chooses "quit"' do
        it do
          allow(subject).to receive(:gets).and_return(Manager::QUIT.to_s)
          expect(subject.main_menu).to eq(Manager::QUIT)
        end
      end
    end

    describe '#save_game_menu' do
      context 'when user types "yes"' do
        it do
          allow(subject).to receive(:gets).and_return('yes')
          expect(subject.save_game_menu).to eq(Manager::SAVE_GAME)
        end
      end

      context 'when user types "no"' do
        it do
          allow(subject).to receive(:gets).and_return('no')
          expect(subject.save_game_menu).to eq(Manager::DO_NOT_SAVE_GAME)
        end
      end
    end

    describe '#get_player_name' do
      context 'when user types his name' do
        it do
          user_name = 'New user name'
          allow(subject).to receive(:gets).and_return(user_name)
          expect(subject.get_player_name).to eq(user_name)
        end
      end
    end

    describe '#process_choice' do

      context 'when user selected to start new game' do
        it do
          # expect(subject).to receive(:start_game)
          expect(subject).to receive(:start_game)
          subject.process_choice(Manager::NEW_GAME)
        end
      end
      context 'when user selected to display saved results' do
        it do
          expect(subject).to receive(:load_saved_games)
          subject.process_choice(Manager::LOAD_SAVED)
        end
      end
      context 'when user selected to quit game' do
        it do
          expect(subject).to receive(:quit)
          subject.process_choice(Manager::QUIT)
        end
      end
    end

    describe 'gameplay' do
      let(:game){ Game.new }
      before do
        game.instance_variable_set(:@secret_code, '2314')
        subject.instance_variable_set(:@current_game, game)
      end
      context 'when game is over' do
        it do
          expect(subject).to receive(:process_choice)
          expect(subject).to receive(:main_menu)
          expect{ subject.send(:game_over) }.to output(/game over/i).to_stdout
        end
      end

      context 'when system call :quit' do
        it do
          expect {subject.send(:quit)}.to raise_error(SystemExit)
        end
      end

      context 'when user made attempt to guess code #1' do
        it do
          expect{ subject.send(:try_guess, '3241') }.to output(/----/i).to_stdout
        end
      end

      context 'when user made attempt to guess code #2' do
        it do
          expect(game).to receive(:check_attempt)
          subject.send(:try_guess, '2314')
        end
      end

      context 'when user made attempt to guess code #3' do
        it do
          expect(subject).to receive(:process_save_request)
          subject.send(:try_guess, '2314')
        end
      end

      context 'when user takes a hint' do
        it do
          expect(game.instance_variable_get(:@secret_code)[0]).to eq('2')
        end
      end

    end
  end
end