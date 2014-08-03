class SessionsController < Devise::SessionsController
  	skip_before_filter :verify_authenticity_token, :only => [:create]

  	def create
  		puts "In sessions create"
  		self.resource = warden.authenticate!(auth_options)
  		set_flash_message(:notice, :signed_in) if is_flashing_format?
  		sign_in(resource_name, resource)
  		yield resource if block_given?
  		respond_to do |format|
          	format.html { redirect_to after_sign_in_path_for(resource) }
  			# respond_with resource, location: after_sign_in_path_for(resource)
  			format.json { render :json => { user: resource, success: true } }
  		end
		# respond_to do |format|
		# 	format.html do
		# 		respond_with resource, location: after_sign_in_path_for(resource)
		# 	end
		# 	format.json do
		# 		render :json => { user: resource, success: true }
		# 	end
		# end
	end
end