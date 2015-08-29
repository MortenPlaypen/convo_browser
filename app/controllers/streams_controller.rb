class StreamsController < ApplicationController
	#include APIHelper
	before_filter :authenticate_user!
	#before_action :check_api_setting
  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
  	#protect_from_forgery with: :exception

	#def hello
	#	render "index" #text: "hello, world!"
	#end

	def index
  		@stream=Stream.new
  		@streams = current_user.streams
  		@email_message = GetConversations.get_conversations(current_user)
  	end

	def create
		@stream=current_user.streams.create(permit_params)
		redirect_to :root
	end

	private
  	def permit_params
    	params.require(:stream).permit(:mailbox_hsid)
  	end
end