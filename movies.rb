require 'sinatra'
require 'csv'
require 'pry'

def movie_list(filename)
  movies = []

  CSV.foreach(filename, headers: true, header_converters: :symbol, converters: :integer) do |row|
    movies << row.to_hash

  end
  movies
end

def movie_titles(movies)
  titles = []
  movies.each do |movie|
    titles << [movie[:title].to_s, movie[:id]]
  end
  titles.sort
end

def movie_info(selected, movie_list)
  movie_info = movie_list.find {|movie| movie[:id] == selected.to_i }
end


get '/movies' do
  @movie_list = movie_list("movies.csv")
  @movie_titles = movie_titles(@movie_list)

  erb :index
end

get '/id/:id' do
  @id = params[:id]
  @movie_list = movie_list("movies.csv")
  @movie_info = movie_info(@id, @movie_list)

  @movie_info.each do |key, value|
    if value != "" && value != nil && key != :id && key != :title
        @key = key
        @value = value
    end
  end

  erb :id
end



