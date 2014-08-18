class SessionsController < Devise::SessionsController
	skip_before_filter :verify_authenticity_token, :only => [:create]

	def create
		puts "In sessions controller"
		puts auth_options
		puts params
		# puts resource.valid_password?
		self.resource = warden.authenticate!(auth_options)
		set_flash_message(:notice, :signed_in) if is_flashing_format?
		puts "before sign_in"
		sign_in(resource_name, resource)
		puts "before signed_in? called"
		puts signed_in?(:user)
		puts current_user
		puts current_user.email
		respond_to do |format|
			format.html { respond_with resource, location: after_sign_in_path_for(resource) }
			format.json { render :json => { user: self.resource, success: true } }
		end
		# if resource.valid_password?(params[:user_login][:password])
		# 	sign_in("user", resource)
		# 	render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login, :email=>resource.email}
		# 	return
		# end
	end
end