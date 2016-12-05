class TessDevise::RegistrationsController < Devise::RegistrationsController
  # Inspired by http://stackoverflow.com/questions/3546289/override-devise-registrations-controller
  prepend_before_action :check_captcha, only: [:create]

  def create
    add_email_to_profile_proc = Proc.new do |res|
        if params[:make_email_public]
          res.profile.update_attribute(:email, res.unconfirmed_email)
        end
    end

    # call parent's create method and pass the proc to modify the profile's email address
    super &add_email_to_profile_proc
  end

  # Set the after update path to be user's show page
  # instead the default root_path
  def after_update_path_for(resource)
    user_path(resource)
  end

  private

  # Pinched from https://github.com/plataformatec/devise/wiki/How-To:-Use-Recaptcha-with-Devise
  def check_captcha
    unless  Rails.application.secrets.captcha_sitekey
      return
    end
    # post to https://www.google.com/recaptcha/api/siteverify
    secret = Rails.application.secrets.captcha_secret
    response = params['g-recaptcha-response']
    uri = URI('https://www.google.com/recaptcha/api/siteverify')
    params = { :secret => secret,
               :response => response,
               :remoteip => request.remote_ip }
    puts "PARAMS: #{params}"
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    json = JSON.parse(res.body)
    puts "JSON: #{json['success']}"
    puts "Secret: #{secret}"
    puts "IP: #{Rails.application.secrets.test_server_ip}"
    unless json['success']
      self.resource = resource_class.new sign_up_params
      respond_with_navigational(resource) { render :new }
    end
  end
end