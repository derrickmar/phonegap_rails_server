class SessionsController < Devise::SessionsController
	# acts_as_token_authentication_handler_for User, except: [:destroy]
	skip_before_filter :verify_authenticity_token, :only => [:create, :destroy]

	# def create
	# 	puts "In sessions controller"
	# 	puts auth_options
	# 	puts params
	# 	# puts resource.valid_password?
	# 	self.resource = warden.authenticate!(auth_options)
	# 	set_flash_message(:notice, :signed_in) if is_flashing_format?
	# 	puts "before sign_in"
	# 	sign_in(resource_name, resource)
	# 	puts "before signed_in? called"
	# 	puts signed_in?(:user)
	# 	puts current_user
	# 	puts current_user.email
	# 	respond_to do |format|
	# 		format.html { respond_with resource, location: after_sign_in_path_for(resource) }
	# 		format.json { render :json => { user: self.resource, success: true } }
	# 	end
	# 	# if resource.valid_password?(params[:user_login][:password])
	# 	# 	sign_in("user", resource)
	# 	# 	render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login, :email=>resource.email}
	# 	# 	return
	# 	# end
	# end

	# POST /resource/sign_in
	def create
		puts 'IN CREATE SessionsController'
		self.resource = warden.authenticate!(auth_options)
		set_flash_message(:notice, :signed_in) if is_flashing_format?
		sign_in(resource_name, resource)
		yield resource if block_given?
		puts current_user.email
		puts resource
		puts params
		respond_to do |format|
			format.html { respond_with resource, location: after_sign_in_path_for(resource) }
			format.json { render :json => { user: resource, success: true } }
		end
	end

	def destroy
		p 'In DESTROY'
		puts params
		binding.pry
		puts current_user
		signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
		puts "is signed_out nil?"
		puts signed_out
		set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
		p 'flash and current_user should print out nil'
		puts flash[:notice]
		puts current_user == nil
		# seems to jump back in front of destroy after this.
		yield if block_given?
		respond_to_on_destroy
	end

	def respond_to_on_destroy
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
    	format.json { render :json => { success: true } }
    	format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
    end
end
end