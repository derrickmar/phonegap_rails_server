class RegistrationsController < Devise::RegistrationsController
  # is there a way to do this so I don't disable CRSF???
  skip_before_filter  :verify_authenticity_token, :only => [:create]
  respond_to :html, :xml, :to_json

  def create
    puts "In RegistrationsController"
    puts sign_up_params
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        puts "user successfully created"
        puts params
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_to do |format|
          format.html { respond_with resource, location: after_sign_up_path_for(resource) }
          format.json { render :json => { user: resource, success: true } }
        end
      else
        puts "resource is inactive"
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_to do |format|
          format.html { redirect_to after_inactive_sign_up_path_for(resource) }
          format.json { render :json => { user: resource, success: false } }
        end
        # render :json => resource
      end
    else
      puts "Sign up failed"
      clean_up_passwords resource
      # render :json => resource
      # render :json => response.to_json
      respond_to do |format|
        format.html { redirect_to after_inactive_sign_up_path_for(resource) }
        format.json { render :json => { resource: resource, success: false} }
      end
      # respond_with resource, location: after_inactive_sign_up_path_for(resource)
      # return render :json => {:success => false}, :callback => params['callback']
    end
  end
end