class PostsController < ApplicationController
   before_action :authenticate_user!, :only => [:new, :create]

   def new
     @movie = Movie.find(params[:movie_id])

     if current_user.is_favorite_of?(@movie)
       @post = Post.new
     else
       redirect_to movie_path(@movie), alert: "收藏电影后才能评论"
     end
   end

   def create
     @movie = Movie.find(params[:movie_id])
     @post = Post.new(post_params)
     @post.movie = @movie
     @post.user = current_user

     if @post.save
       redirect_to movie_path(@movie)
     else
       render :new
     end
   end

   private

   def post_params
     params.require(:post).permit(:content)
   end
end
