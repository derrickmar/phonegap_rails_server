class UsersController < ApplicationController
  	skip_before_filter :verify_authenticity_token, :only => [:update, :still_validated]

	def show
	end

	def still_validated
		@user = User.find(params[:id])
		render :json => { user: @user, success: true } 
	end

	def update
		@user = User.find(params[:id])
		puts @user
		@user.update(user_params)
		# request.headers.each do |r|
		# 	puts r
		# end
		# @user.update()
		respond_to do |format|
			format.html { redirect_to users_path }
			format.json { render :json => { user: @user, success: true } }
		end
	end

	def index
		@users = User.all
		puts "INDEX ACTION OF USERS"
		respond_with(@users)
		# respond_to do |format|
		# 	format.html
		# 	format.json { render :json => { users: @users } }
		# 	# format.xml  { render :xml => @users }
		# 	# format.json { render :json => { users: @users } }
		# end
	end

	def user_params
		params.require(:user).permit(:email, :counter)
	end
end
