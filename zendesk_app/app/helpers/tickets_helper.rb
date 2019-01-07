module TicketsHelper

	def all_tickets
		page_number = params[:page]

		response = HTTParty.get(Rails.application.config.zendesk_api_url + "?page=#{page_number}", :basic_auth => auth)
	end

	def show_ticket
		response = HTTParty.get(Rails.application.config.zendesk_api_ticket_url + "#{params[:id]}.json", :basic_auth => auth)
	end

	def create_ticket
		post_data = {
			"ticket": {
				"external_id": params[:external_id],
				"type": params[:type],
				"subject": params[:subject],
				"comment": {"body": params[:description] },
				"priority": params[:priority],
				"status": params[:status],
				"recipient": params[:recipient],
			}
		}
		response = HTTParty.post(Rails.application.config.zendesk_api_url, :basic_auth => auth, :body => post_data)		
	end

	private

	def auth
		{:username => "#{session[:user_email]}/token", :password => Rails.application.config.zendesk_api_token}
	end
end
