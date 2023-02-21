require "open-uri"

class GamesController < ApplicationController

  def new
    # criar uma array com letras random, sem repetir letras e armazenar em uma instancia
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(' ')

    call_api

    @word_in_grid = check_word_in_grid

    compute_score(@letters)
  end

  private

  def call_api
    @res = URI.open("https://wagon-dictionary.herokuapp.com/#{@word}")
    @json = JSON.parse(@res.read)
  end

  def check_word_in_grid
    @word.chars.all? { |char| @word.chars.count(char) <= @letters.count(char) }
  end

  def compute_score(letters)
    @output = ""
    if @word_in_grid
      if @json["found"]
        @output= "Congratulations! #{@word.upcase} is a valid English word!"
      else
       @output = "Sorry but #{@word.upcase} does not seem to be a valid English word..."
      end
    else
      @output = "Sorry but #{@word.upcase} can't be built out of #{letters}"
    end
  end
end
