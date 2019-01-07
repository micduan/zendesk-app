class ApplicationController < ActionController::Base
	include ApplicationHelper

	def index
	end

	def create
		set_session_email(params[:user_email])
		render action: "index"
	end
end
