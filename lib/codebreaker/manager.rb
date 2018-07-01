module Codebreaker
  class Manager
    NEW_GAME = 1
    LOAD_SAVED = 2
    QUIT = 3
    SAVE_GAME = 4
    DO_NOT_SAVE_GAME = 5

    attr_reader :current_game

    def begin
      process_choice main_menu
    end

    def process_choice(choice)
      case choice
      when NEW_GAME
        start_game
      when LOAD_SAVED
        load_saved_games
      when QUIT
        quit
      else
        raise 'Selected wrong choice!'
      end
    end

    def main_menu
      menu_items = {
          '1' => :new_game,
          '2' => :load_saved_results,
          '3' => :quit,
      }

      while true
        puts '====================================='
        menu_items.each{ |key, value| puts "#{key} => #{format_item(value)}" }
        puts '====================================='
        print 'Make your choice: '

        user_choise = gets.chomp

        if menu_items.key?(user_choise)
          user_choise_label = menu_items[user_choise]
          puts format_item(user_choise_label)

          case user_choise_label
            when :new_game
              return NEW_GAME
            when :load_saved_results
              return LOAD_SAVED
            when :quit
              return QUIT
          end
        else
          puts "\n" + 'Please, enter correct value'
        end
      end
    end

    def save_game_menu
      puts 'Do you want to save game results? (yes/no)'
      while true
        user_data = gets.chomp.downcase
        if 'yes' == user_data
          puts 'your data is saved'
          return SAVE_GAME
        elsif 'no' == user_data
          return DO_NOT_SAVE_GAME
        else
          puts 'Enter \'yes\' or \'no\''
        end
      end
    end

    def get_player_name
      print 'Enter your name: '
      gets.chomp
    end

    private

    def start_game
      puts 'New game has been started!'
      puts 'You should enter number between 1111 and 6666, "h" for help, or "q" for exit'
      init_game
      while @current_game.attempt_available?
        print 'Your answer: '
        answer = gets.chomp.downcase
        case answer
        when 'h'
          take_hint
        when 'q'
          quit
        when correct_answer_pattern
          process_answer answer
        else
          puts 'Incorrect answer!'
        end
      end
      game_over
    end

    def quit
      abort 'Bye'
    end

    def correct_answer_pattern
      /^[1-6]{4}$/
    end

    def init_game
      @current_game = Game.new
    end	    

    def process_answer(answer)
      @current_game.use_attempt
      try_guess answer
    end

    def try_guess(answer)
      game_result = @current_game.check_attempt(answer)
      puts "Game result: #{game_result}"
      if '++++' == game_result
        puts ''
        puts '++++++++++++++++++++++'
        puts '| Congrats! You win! |'
        puts '++++++++++++++++++++++'
        @current_game.game_win
        process_save_request
      end
    end

    def game_over
      puts ''
      puts '++++++++++++++'
      puts '| Game over! |'
      puts '++++++++++++++'
      @current_game.game_lost
      process_choice main_menu
    end

    def take_hint
      if @current_game.hint_available?
        puts "First number: #{@current_game.take_hint}"
      else
        puts 'You\'ve already taken a hint!'
      end
    end

    def process_save_request
      if SAVE_GAME == save_game_menu
        load_data_manipulator.add_game(get_player_name, @current_game.game_win?, @current_game.attempts_used, !@current_game.hint_available?)
      end
      process_choice main_menu
    end

    def load_saved_games
      display_saved_games load_data_manipulator.return_all_data
      process_choice main_menu
    end

    def load_data_manipulator
      @data_manipulator = DataManipulator.new unless defined? @data_manipulator
      @data_manipulator
    end

    def display_saved_games(games)
      if games.length.zero?
        puts 'There are no data for display'
      else
        col_size = 20
        puts make_separator_line(col_size, 5)
        puts '|' + 'User name'.ljust(col_size) + '|' + 'Game status'.ljust(col_size) + '|' + 'Attempts'.ljust(col_size) +
          '|' + 'Hint'.ljust(col_size) + '|' + 'Date'.ljust(col_size) + '|'
        puts make_separator_line(col_size, 5)
        games.each do |game|
          puts "|#{game[:user_name].ljust(col_size)}|#{game[:game_status].ljust(col_size)}|#{game[:attempts_count].to_s.ljust(col_size)}|#{game[:hint].ljust(col_size)}|#{game[:date].ljust(col_size)}|"
        end
        puts make_separator_line(col_size, 5)
      end
    end

    def make_separator_line(col_size, col_count)
      ' ' + ('-' * ((col_size * col_count) + (col_count - 1))) + ' '
    end

    def format_item(item)
      item.to_s.capitalize.gsub('_', ' ')
    end
  end
end
