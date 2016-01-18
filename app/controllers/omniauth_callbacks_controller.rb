class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    enter_via_social_network('Facebook')
  end

  def vk
    enter_via_social_network('VK')
  end

  private

  def enter_via_social_network(name)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: name) if is_navigational_format?
    end
  end
end