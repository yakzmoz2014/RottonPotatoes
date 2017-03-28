class MoviesController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_movie_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @movies = Movie.all
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user
    if @movie.save
      current_user.favorite!(@movie)
      redirect_to movies_path
    else
      render :new
    end
  end

  def show
    @movie = Movie.find(params[:id])
    @posts = @movie.posts.recent.paginate(:page => params[:page], :per_page => 25)
  end

  def edit
  end

  def update
    if @movie.update(movie_params)
      redirect_to movies_path, notice: "Update success!"
    else
      render :edit
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_path, alert: "Movie was deleted!"
  end

  def favorite
    @movie = Movie.find(params[:id])

    if !current_user.is_favorite_of?(@movie)
      current_user.favorite!(@movie)
      flash[:notice] = "加入Favorite列表成功！"
    else
      flash[:warning] = "已经存在Favorite列表，请勿重复添加！"
    end

    redirect_to movie_path(@movie)
  end

  def not_favorite
    @movie = Movie.find(params[:id])

    if current_user.is_favorite_of?(@movie)
      current_user.not_favorite!(@movie)
      flash[:alert] = "已经从Favorite列表移除！"
    else
      flash[:warning] = "尚未加入Favorite列表"
    end
    redirect_to movie_path(@movie)
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :description, :image)
  end

  def find_movie_and_check_permission
    @movie = Movie.find(params[:id])

    if current_user != @movie.user
      redirect_to root_path, alert: "You have no permission."
    end
  end
end
