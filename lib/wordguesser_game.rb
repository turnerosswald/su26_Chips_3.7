class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(word)
    raise ArgumentError if word.nil?
    raise ArgumentError unless word.match?(/\A[a-z]\z/i)
    word = word.downcase
    if guesses.include?(word) || wrong_guesses.include?(word)
      return false
    end
    if @word.include?(word)
      @guesses += word
    else
      @wrong_guesses += word
    end
  end

  def word_with_guesses()
    print_word = ''
    @word.chars.each do |char|
      if @guesses.include?(char)
        print_word += char
      else 
        print_word += '-'
      end
    end
    print_word
  end
  
  def check_win_or_lose()
    if @guesses.length + @wrong_guesses.length >= 7
      :lose
    elsif word_with_guesses().include?('-')
      :play
    else
      :win
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://randomword.saasbook.info/RandomWord')
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      response = http.get(uri.path)
      return response.body.scan(/<div>(.+?)<\/div>/).flatten.first
    end
  end
end
