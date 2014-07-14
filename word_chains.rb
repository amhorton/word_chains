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

    @dictionary.keep_if { |dict_word| dict_word.length == word.length }

    @dictionary.each do |word|
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

  def explore_current_words
    new_current_words = []

    @current_words.each do |word|

      adjacent_words(word).each do |adj_word|
        next if @all_seen_words.include?(adj_word)

        new_current_words << adj_word

        @all_seen_words[adj_word] = word
      end

    end

    @current_words = new_current_words
  end

  def build_path(target, path = [target])

    return path if @all_seen_words[target] == nil

    path << @all_seen_words[target]

    self.build_path(@all_seen_words[target], path)
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = { source => nil}

    until @all_seen_words.has_key?(target)
      explore_current_words
    end

    self.build_path(target)
  end
end