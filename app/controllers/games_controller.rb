require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array("A".."Z").sample(10)
  end

  def score
    # check if the letters of the word match letters from @letters.
    input_letters = params[:word].upcase
    @letters = params[:letters].split
    letter_match = included?(input_letters, @letters)
    # parse the dictionary API
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    dictionary_sterilized = open(url).read
    dictionary = JSON.parse(dictionary_sterilized)

    # check if the word is included in the dictionary API,
    if letter_match == false
      @response = "sorry #{params[:word]} cannot be built from #{@letters}"
    elsif dictionary["found"] == false
      @response = "sorry #{params[:word]} is not an english word"
    else
      @response = "Yay they match!"
    end
  end

  def included?(input_letters, letters)
    input_letters.chars.all? { |letter| input_letters.count(letter) <= letters.count(letter) }
  end
end
