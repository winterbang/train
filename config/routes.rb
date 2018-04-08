Rails.application.routes.draw do
  # cable
  # mount ActionCable.server => "/cable"
  def draw(routes_name)
    instance_eval File.read(Rails.root.join("config/routes/#{routes_name}.rb"))
  end

  # mount_devise_token_auth_for 'User', at: 'auth', controllers: {
  #   registrations:  'authentication_rails/registrations',
  #   sessions:       'authentication_rails/sessions',
  #   passwords:      'authentication_rails/passwords',
  #   confirmations:  'authentication_rails/confirmations',
  # }

  # defaults format: :json do
  #   draw :api
  #   draw :admin
  # end

end
