class UserSessionsController < ApplicationController
 	 def new
 	 end

  	def create
  		user = User.find_by(email: params[:email])
  		if user && user.authenticate(params[:password])
  			session[:user_id] = user.id
  			flash[:success] = "Thanks for logging in!"
  			redirect_to todo_lists_path
 		else
 			flash[:error] = "There was a problem loggin in. Please check your email and password."
  			render action: 'new'
  		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_path
	end




end
