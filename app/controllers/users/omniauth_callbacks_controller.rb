class Users::OmniauthCallbacksController < ApplicationController
  def linkedin
    omniauth = request.env["omniauth.auth"]
    credentials = omniauth["credentials"]

    # First lets check if the user is logged in or not
    if current_user
      # The user is logged in
      # Check if a user exists with that uid
      if User.where(linkedin_uid: omniauth['uid']).exists?
        # If the user is the same, login, otherwise, warn that there is another user with that uid
        if User.where(linkedin_uid: omniauth['uid']).first.id == current_user.id
          # Update the credentials
          current_user.linkedin_token = credentials['token']
          current_user.linkedin_password = credentials['password']
          current_user.save

          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Linkedin"
          sign_in(user)
        else
          flash[:alert] = "There is another user registered with your linkedin account"
          redirect_to root_path
        end
      else
        # If the current account is linkted to another account, alert and redirect
        if current_user.linkedin_uid.blank?
          # Just link the account
          client = LinkedIn::Client.new(LINKEDIN_KEY, LINKEDIN_SECRET)
          client.authorize_from_request(credentials['token'], credentials['secret'])

          data = client.profile(fields: %w(email-address first_name last_name headline industry picture-url public-profile-url))

          user.linkedin_uid = omniauth['uid']

          current_user.linkedin_token = credentials['token']
          current_user.linkedin_password = credentials['password']

          current_user.first_name = data['first_name']
          current_user.last_name = data['last_name']
          current_user.headline = data['headline']
          current_user.industry = data['industry']
          current_user.picture_url = data['picture-url']
          current_user.public_profile_url = data['public-profile-url']
          current_user.save

          flash[:notice] = "Your LinkedIn account was linked"
        else
          # The account is linkted to another linkedin account
          flash[:alert] = "Your account is linkted to another linkedin account"
        end
        redirect_to root_path
      end
    else
      # The user is not logged in
      # Check if there is a user with that uid, if it exists, login and redirect, otherwise fetch email and redirect
      if User.where(linkedin_uid: omniauth['uid']).exists?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Linkedin"
        sign_in(User.where(linkedin_uid: omniauth['uid']).first)
      else
        # The user doesn't exists, fetch the email, register and sign in
        client = LinkedIn::Client.new(LINKEDIN_KEY, LINKEDIN_SECRET)
        client.authorize_from_request(credentials['token'], credentials['secret'])

        data = client.profile(fields: %w(email-address first_name last_name headline industry picture-url public-profile-url))

        user = User.new

        user.linkedin_uid = omniauth['uid']
        user.linkedin_token = credentials['token']
        user.linkedin_password = credentials['password']

        user.email = data['email-address']
        user.first_name = data['first_name']
        user.last_name = data['last_name']
        user.headline = data['headline']
        user.industry = data['industry']
        user.picture_url = data['picture-url']
        user.public_profile_url = data['public-profile-url']
        user.save


        user.password = user.password_confirmation = generate_password
        user.save

        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Linkedin"
        sign_in(user)
      end
    end
  end

  private

  def generate_password
    (0...8).map{65.+(rand(25)).chr}.join
  end
end
