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
                                          summary: position['summary'],
                                          title: position['title'])
          position.user_id = current_user.id
          position.save
        end
      end

      # Fetch the user connections
    end
  end
end
