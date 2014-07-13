require 'set'

class WordChainer

  def initialize(dictionary_file_name)
    @dictionary = []
    File.foreach(dictionary_file_name) do |line|
      @dictionary << line.chomp
    end
    @dictionary = @dictionary.to_set
  end

  def adjacent_words(word)
    adjacents = []

    word_arr = word.split("")

    right_length = @dictionary.select! { |dict_word| dict_word.length == word.length }

    right_length.each do |word|
      i = 0

      word.split("").each_with_index do |char, index|
        if char != word_arr[index]
          i += 1
        end
      end

      adjacents << word if i == 1
    end

    adjacents
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = [source]
    until @current_words.empty?
      new_current_words = []

      @current_words.each do |word|

        adjacent_words(word).each do |adj_word|
          next if @all_seen_words.include?(adj_word)
          new_current_words << adj_word
          @all_seen_words << adj_word
        end

      end

      p new_current_words

      @current_words = new_current_words
    end
  end
end

my_chainer = WordChainer.new("dictionary.txt")

p my_chainer.run("frog", "parked")