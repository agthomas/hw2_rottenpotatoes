class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
#debugger
    @all_ratings = Movie.all_ratings
    if params.include?(:commit)
      if params.include?(:ratings)
        session[:ratings]=params[:ratings]
        @selected_ratings = params[:ratings]
        @movies = Movie.find(:all, :conditions => { :rating => @selected_ratings.keys})
      else
        if session.include?(:ratings)
          session.delete(:ratings)
        end
        @movies = Movie.all
      end
    elsif params.include?(:sortby)
      @sortby = params[:sortby]
      session[:sortby]=@sortby
      @selected_ratings = session[:ratings]
      if @selected_ratings == nil
        @movies = Movie.find(:all,:order => @sortby)
      else
#@movies = Movie.find(:all, :conditions => { :rating => @selected_ratings.keys}, :order => @sortby)
        @movies = Movie.where(:rating => @selected_ratings.keys).order(@sortby)
      end
    else
      if session.include?(:sortby)
        redirect_to :action => 'index', :sortby => session[:sortby]
      elsif session.include?(:ratings)
        redirect_to :action => 'index', :commit =>'Refresh', :ratings => session[:ratings] 
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
