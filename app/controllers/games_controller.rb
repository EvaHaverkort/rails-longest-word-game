require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
    @input = params[:input]
  end

  def included?(input, letters)
    input.chars.all? { |letter| input.count(letter) <= letters.count(letter) } # chars.all?
  end

  def compute_score(input)
    input.size * 60.0
  end

  def english_word?(input)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{input}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def score
    @input = params[:input]
    @letters = params[:letters]
    @total_score = 0
    @message = ""
    if included?(@input, @letters)
      if english_word?(@input)
        @total_score = compute_score(@input)
        @message = "winner"
      else
        @message = "not english"
      end
    else
      @message = "impossible"
    end
  end
end
