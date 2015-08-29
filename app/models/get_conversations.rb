require 'httparty'

class GetConversations
	include HTTParty

	def self.get_conversations(current_user)
		date = (Time.now.utc - 14.days).strftime("%Y-%m-%dT%H:%M:%SZ")
		stream = current_user.streams.first
		auth = {:password => "X", :username => current_user.helpscout_token}
		api_url = "https://api.helpscout.net/v1/mailboxes/#{stream.mailbox_hsid}/conversations.json?modifiedSince=#{date}"
		response = HTTParty.get(URI.encode(api_url), :basic_auth => auth)
		ret_hash = {}
		emails_arr = []
		response["items"].each do |item|
			if item["createdAt"] > DateTime.now - 7
			
				email_hash = {}
				conversation_id = item["id"]
				thread_response = HTTParty.get(URI.encode("https://api.helpscout.net/v1/conversations/#{conversation_id}.json"), :basic_auth => auth)
				email_hash = { :email_subject => thread_response['item']['subject'], :email_body => thread_response['item']['threads'].last['body'], :email_date => thread_response['item']['createdAt'].to_time.strftime("%m-%d-%Y-%H:%M") }
				emails_arr.push(email_hash)
			end
		end
		this_week = emails_arr.count
		last_week = response["items"].count - emails_arr.count
		end_day = (Time.now.utc).strftime("%m/%d")
		start_day = (Time.now.utc - 7.days).strftime("%m/%d")
		ret_hash = { :last_week => last_week, :this_week => this_week, :end_day => end_day, :start_day => start_day, :emails => emails_arr }
		return ret_hash
	end
end
