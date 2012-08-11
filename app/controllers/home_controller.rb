class HomeController < ApplicationController
  before_filter :authenticate_user!, only: 'protected_page'
  before_filter :fetch_linkedin_information, only: 'index'

  # Just fetch all the linkedin for the user
  def fetch_linkedin_information
    if current_user && !current_user.linkedin_uid.blank?
      client = current_user.linkedin_client

      # Fetch the user positions
      user_positions = client.profile(:fields => %w(positions))
      LinkedinPosition.where(user_id: current_user.id).delete_all()
      if user_positions['positions']['total'].to_i > 0
        user_positions['positions']['all'].each do |position|
          if LinkedinCompany.where(linkedin_id: position['company']['id']).exists?
            company = LinkedinCompany.where(linkedin_id: position['company']['id'].to_i).first
          else
            company = LinkedinCompany.new(linkedin_id: position['company']['id'].to_i,
                                          industry: position['company']['industry'],
                                          name: position['company']['name'],
                                          company_type: position['company']['type'],
                                          ticker: position['company']['ticker'])
            company.save
          end
          position = LinkedinPosition.new(linkedin_id: position['id'].to_i,
                                          linkedin_company: company,
                                          is_current: position['is_current'],
                                          start_date: Date.strptime("#{position['start_date']['month']}/#{position['start_date']['year']}", '%m/%Y'),
                                          end_date: (Date.strptime("#{position['end_date']['month']}/#{position['end_date']['year']}", '%m/%Y') rescue nil),
                                          summary: position['summary'],
                                          title: position['title'])
          position.user_id = current_user.id
          position.save
        end
      end

      # User connections
      connections = client.connections
      if connections['total'].to_i > 0
        connections['all'].each do |connection|
          if LinkedinConnection.where(linkedin_id: connection['id']).exists?
            linkedin_connection = LinkedinConnection.where(linkedin_id: connection['id']).first
          else
            linkedin_connection = LinkedinConnection.new(linkedin_id: connection['id'])
          end
          linkedin_location = nil
          begin
            if LinkedinLocation.where(code: connection['location']['country']['code']).exists?
              linkedin_location = LinkedinLocation.where(code: connection['location']['country']['code']).first
            else
              linkedin_location = LinkedinLocation.new(code: connection['location']['country']['code'],
                                                       name: connection['location']['name'])
              linkedin_location.save
            end
          rescue Exception
          end

          linkedin_connection.linkedin_location = linkedin_location

          linkedin_connection.first_name = connection['first_name']
          linkedin_connection.last_name = connection['last_name']
          linkedin_connection.headline = connection['headline']
          linkedin_connection.industry = connection['industry']
          linkedin_connection.picture_url = connection['picture_url']
          linkedin_connection.public_profile_url = connection['site_standard_profile_request']['url'] rescue nil

          linkedin_connection.save

          linkedin_connection.users << current_user unless linkedin_connection.users.include?(current_user)
        end
      end

      # Fetch the user connections
    end
  end
end
