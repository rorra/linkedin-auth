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
          assign_linkedin_credentials(user, credentials, omniauth['uid'])

          current_user.save

          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Linkedin"
          sign_in(current_user)
          redirect_to after_sign_in_path_for(current_user)
        else
          flash[:alert] = "There is another user registered with your linkedin account"
          redirect_to root_path
        end
      else
        # Check that the current user is not linked to another linkedin account
        if current_user.linkedin_uid.blank?
          # Just link the account
          client = LinkedIn::Client.new(LINKEDIN_KEY, LINKEDIN_SECRET)
          client.authorize_from_access(credentials['token'], credentials['secret'])

          data = client.profile(fields: %w(email-address first_name last_name headline industry picture-url public-profile-url))

          assign_linkedin_credentials(user, credentials, omniauth['uid'])
          assign_linkedin_data(user, data)

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
      # Check if there is a user with that uid, if it exists, login and redirect, otherwise create the user
      if User.where(linkedin_uid: omniauth['uid']).exists?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Linkedin"
        user = User.where(linkedin_uid: omniauth['uid']).first
        sign_in(user)
      else
        # The user doesn't exists, fetch the email, register and sign in
        client = LinkedIn::Client.new(LINKEDIN_KEY, LINKEDIN_SECRET)
        client.authorize_from_access(credentials['token'], credentials['secret'])

        data = client.profile(fields: %w(email-address first_name last_name headline industry picture-url public-profile-url))

        user = User.new

        assign_linkedin_credentials(user, credentials, omniauth['uid'])
        assign_linkedin_data(user, data, true)
        user.password = user.password_confirmation = generate_password

        user.save

        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Linkedin"
        sign_in(user)
      end
      redirect_to after_sign_in_path_for(user)
    end
  end

  private

  def assign_linkedin_credentials(user, credentials, uid = nil)
    user.linkedin_uid = uid unless uid.blank?
    user.linkedin_token = credentials['token']
    user.linkedin_secret = credentials['secret']
    user
  end

  def assign_linkedin_data(user, data, email = false)
    user.email = data['email_address'] if email
    user.first_name = data['first_name']
    user.last_name = data['last_name']
    user.headline = data['headline']
    user.industry = data['industry']
    user.picture_url = data['picture_url']
    user.public_profile_url = data['public_profile_url']
    user
  end

  def generate_password
    (0...8).map{65.+(rand(25)).chr}.join
  end
end
