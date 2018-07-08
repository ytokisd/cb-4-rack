require_relative 'processor.rb'
require_relative 'data_manager.rb'
require_relative 'interface.rb'

# Comment
module Codebreaker
class Game
  ATTEMPTS_AMOUNT = 5.freeze
  include Interface

  attr_reader :code, :attempts_amount

  def initialize
    @code = generator
    @processor = Processor.new
    @manager = DataManager.new
    @hint_avaliable = true
  end

  def generator
    Array.new(4) { rand(1..6) }
  end

  def game_preparations
    @code = generator
    @attempts = 3
    @game_end = false
    @hint_avaliable = true
  end

  def new_game
    game_preparations
    turn_start_message
    loop do
      result = choice_processor
      attempts
      win(result)
      break if @game_end
      lost
      break if @game_end
    end
    save_results_message
    save_results?
  end

  def attempt_available?
    return false unless attempts > 0
    true
  end

  def hint_available?
    @hint_avaliable
  end

  def use_attempt
    @attempts -= 1 if attempt_available?
  end

  def attempts
    @attempts = @processor.attempts_left
  end

  def win(result)
    win_condition = Array.new(4, '+')
    return unless result == win_condition
    win_game_message
    @game_end = true
  end

  def game_win
    @game_win = true
  end

  def game_win?
    @game_win
  end

  def lost
    return unless @attempts.zero?
    lost_game_message
    @game_end = true
  end

  def game_lost
    @game_win = false
  end

  def choice_processor
    command = gets.chomp
    commands.dig(command.to_sym).call unless command =~ /^[1-6]{4}$/
    @processor.turn_processor(@code, command)
  rescue
    puts 'Please give a valid command'
    retry
  end

  def check_attempt(command)
    @processor.turn_processor(@code, command)
  end

  def take_hint
    return have_no_hints_message unless @hint_avaliable == true
    @hint_avaliable = false
    hint_value = @processor.hint_processor(@code)
    hint_value
  end

  def exit_game
    exit
  end

  def save_results?
    choice = gets.chomp.downcase
    choice == 'yes' ? @manager.write_results(@attempts, @hint_avaliable) : ' '
  end

  def commands
    {
      h: -> { take_hint },
      q: -> { exit_game }
    }
  end
end
end

#a = Codebreaker::Game.new
#p a.take_hint
