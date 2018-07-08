require_relative 'game.rb'
require_relative 'data_manager.rb'
require_relative 'interface.rb'
# comment
module Codebreaker
class Menu
  attr_reader :current_game

  include Interface
  def initialize
#    @game = Game.new
    @manager = DataManager.new
  end

  def game_menu
    loop do
      main_menu_message
      choice = gets.chomp
      choice_processor(choice)
    end
    rescue
      puts 'Please give a valid command'
      retry
  end

  def init_game
    @current_game = Game.new
  end

  def run_manager
    @manager = DataManager.new unless defined? @manager
    @manager
  end

  def start_game
    init_game.new_game
  end

  def exit_game
    exit
  end

  def read_results
    @manager.view_results
  end

  def commands
    {
      p: -> { start_game },
      q: -> { exit_game },
      r: -> { read_results }
    }
  end

  def choice_processor(command_name)
    commands.dig(command_name.to_sym).call
  end

  def correct_answer
    Array.new(4, '+')
  end
end
end