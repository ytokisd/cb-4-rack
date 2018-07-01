module Codebreaker
  class Game

    attr_reader :secret_code, :attempts_amount
    ATTEMPTS_AMOUNT = 5.freeze
    def initialize
      @secret_code = (1..4).map { rand(1..6) }.join
      @can_take_hint = true
      @attempts_amount = ATTEMPTS_AMOUNT
    end

    def check_attempt(guess_code)
      result = ''
      pluses_count = intersection_with_index_length(guess_code, @secret_code)
      coincidences_count = intersection_without_index_length(guess_code, @secret_code)
      result += '+' * pluses_count
      result += '-' * (coincidences_count - pluses_count)
    end

    def hint_available?
      @can_take_hint
    end

    def take_hint
      if hint_available?
        @can_take_hint = false
        @secret_code[0]
      end
    end

    def attempt_available?
      !@attempts_amount.zero?
    end

    def use_attempt
      @attempts_amount -= 1 if attempt_available?
    end

    def attempts_used
      ATTEMPTS_AMOUNT - @attempts_amount
    end

    def game_win
      @game_win = true
    end

    def game_win?
      @game_win
    end

    def game_lost
      @game_win = false
    end

    private

    def intersection_with_index_length(stg1, stg2)
      stg1.split(//).zip(stg2.split(//)).select { |x, y| x == y }.length
    end

    def intersection_without_index_length(stg1, stg2)
      stg2.split(//).inject(0) do |sum, char|
        sum += 1 if stg1.sub!(char,'')
        sum
      end
    end

  end
end