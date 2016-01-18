require 'rails_helper'

feature "OmniAuth sign-in", %q{
        In order to user an existing social network account to sign in,
        As a registered social account user,
        I am able to sign in via Facebook and VK
} do

  scenario "A guest tries to sign in" do
    visit new_user_session_path
    expect(page).to have_link "Sign in with Facebook"
    expect(page).to have_link "Sign in with Vk"
  end
end