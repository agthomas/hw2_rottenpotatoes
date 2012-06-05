class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sortby = params[:sortby]
    @all_ratings = Movie.all_ratings
    if @sortby != nil
      @selected_ratings = params[:selected_ratings]
      if @selected_ratings == nil
        @movies = Movie.find(:all,:order => @sortby)
      else
        @movies = Movie.find(:all, :conditions => { :rating => @selected_ratings.keys}, :order => @orderby)
      end
    else
      @selected_ratings = params[:ratings]
      if @selected_ratings != nil
        @movies = Movie.find(:all, :conditions => { :rating => @selected_ratings.keys})
      else
        @movies = Movie.all
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
