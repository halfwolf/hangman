class Hangman
  
  def initialize(guessing_player, checking_player)
    @guesser = guessing_player
    @referee = checking_player
    @encoded_word = []
    @guesses = 0
  end
  
  def play
    play_game
  end
  
  def play_game
    @encoded_word = @referee.pick_secret_word
    
    until won? || over?
      pass_secret_length
      handle_guessing
      @guesses += 1
    end
    
    print_result
  end
  
  def pass_secret_length
    @guesser.receive_secret_length(@encoded_word)
  end
  
  def handle_guessing
    guess = @guesser.guess
    @encoded_word = @referee.receive_guess_response(guess)
  end
  
  def won?
    return true if !@encoded_word.include?(nil) && !@encoded_word.empty?
    false
  end
  
  def over?
    return true if @guesses >= 10
    false
  end
  
  def print_result
    if won?
      puts "Guesser has won!" 
      puts "Secret Word was #{@encoded_word.join("")}"
    else
      puts "Referee has won! The word will never be revealed O_o "
    end
    
  end
  
end

class ComputerPlayer
  
  def initialize(dictionary_path)
    @dictionary = load_dictionary(dictionary_path)
    @secret_word = ''
    @guessed_letters = []
    @alphabet = ('a'..'z').to_a.shuffle
    @short_dictionary = nil
  end
  
  # computer as ref
  def pick_secret_word
    @secret_word = choose_secret_word
    length = []
    @secret_word.length.times { length << nil }
    length
  end

  def receive_guess_response(guess)
    @guessed_letters << guess
    @secret_word.split("").map { |letter| @guessed_letters.include?(letter) ? letter : nil }
  end
  
  # computer as player
  def receive_secret_length(encoded_word)
    @secret_word = encoded_word
    if @short_dictionary.nil?
      length = @secret_word.length
      @short_dictionary = @dictionary.select {|word| word.length == length }
    end
  end
  
  def guess
    revise_words
    choose_best_letter
  end
  
  private
  
  def load_dictionary(dictionary_path)
    File.open(dictionary_path).map(&:chomp)  
  end
  
  def choose_secret_word
    @dictionary.sample
  end
  
  def secret_word
    @secret_word
  end
  
  def revise_words
    updated_dictionary = @short_dictionary.select do |word|
      word_passes?(word)
    end
    
    @short_dictionary = updated_dictionary
  end
  
  def word_passes?(word)
    word.split("").each_index do |idx|
      if @secret_word[idx].nil?
        next if @guessed_letters.nil?
        return false if @guessed_letters.include?(word[idx])
      else
        return false if word[idx] != @secret_word[idx]
      end
    end
    
    true
  end
  
  def choose_best_letter
    best_letter = ''
    best_count = 0
    compounded_dictionary = @short_dictionary.join("")
    ('a'..'z').each do |letter|
      letter_count = compounded_dictionary.scan(letter).count
      puts "#{letter_count} = #{letter}"
      if letter_count > best_count && !@guessed_letters.include?(letter)
        best_letter = letter 
        best_count = letter_count
      end
    end
    @guessed_letters << best_letter
    
    best_letter
  end  
  
end

class HumanPlayer
  def initialize
    @secret_word = []
  end
  
  def receive_secret_length(word)
    decoded_word = word.map { |letter| letter.nil? ? "_" : letter }
    print "Secret Word: #{decoded_word.join("")}"
  end
  
  def guess
    guess = false
    puts "Enter a letter"      
    until guess
      guess = gets.chomp
      if !('a'..'z').include?(guess)
        puts "Invalid guess"
        guess = false
      end
    end
    return guess
  end
  
  def pick_secret_word
    puts "enter secret word length"
    length = gets.chomp
    length.to_i.times { @secret_word << nil }
    @secret_word
  end
  
  def receive_guess_response(guess)
    puts "Computer guesses #{guess}"
    puts "Is this letter included?"
    yes_or_no = gets.chomp
    if yes_or_no == 'y'
      puts "enter new encoded word"
      @secret_word.length.times do |idx|
        letter = gets.chomp
        letter.empty? ? @secret_word[idx] = nil : @secret_word[idx] = letter
      end
    end
    @secret_word
  end
  
    
  
  
end