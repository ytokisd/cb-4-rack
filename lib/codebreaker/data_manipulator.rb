require 'yaml'
require 'fileutils'
require 'active_support/time'

module Codebreaker
  class DataManipulator
    STORAGE = 'data/storage.yml'

    def add_game(user_name, is_game_win, attempts_count, hint_used)
      load_data unless defined? @storage_data
      @storage_data << {
          user_name: user_name,
          game_status: is_game_win ? 'Win' : 'Lose',
          attempts_count: attempts_count,
          hint: hint_used ? 'Used' : 'Saved',
          date: Time.current.strftime('%d/%m/%Y %H:%M:%S')
      }
      write_data(@storage_data)
    end

    def return_all_data
      load_data unless defined? @storage_data
      @storage_data
    end

    def load_data
      no_data = []
      @storage_data = File.file?(STORAGE) ? (YAML.load_file(STORAGE) || no_data) : no_data
    end

    def write_data(data)
      dirname = File.dirname(STORAGE)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
      File.open(STORAGE, 'w') { |f| f.write(data.to_yaml) }
    end
  end
end