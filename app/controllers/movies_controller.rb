class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #Create all ratings variables
    @all_ratings =  Movie.all_ratings
    #Set default values for parameters
    @defaults = {ratings: nil, sort_by: nil}
    params.replace(@defaults.merge(params)) 
    #Variables for storing the selected ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
      session[:ratings] = @selected_ratings
    end
    #Filter movies based on selected ratings
    @movies = Movie.where(rating: @selected_ratings.keys).order(params[:sort_by])
    @sort_column = params[:sort_by]
    #Store parameters into session
    if (params[:sort_by].to_s == 'title')
      session[:sort_by] = params[:sort_by]
    elsif(params[:sort_by].to_s == 'release_date')
      session[:sort_by] = params[:sort_by]
    else session[:sort_by] = nil
    # elsif(params[:sort_by] != nil)
    #   session[:sort_by] = params[:sort_by]
    # elsif(session.has_key?(:sort_by))
    #   params[:sort_by] = session[:sort_by]
    end
  
    if(params[:ratings] != nil)
      session[:ratings] = params[:ratings]
    elsif(session.has_key?(:ratings))
      params[:ratings] = session[:ratings]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
