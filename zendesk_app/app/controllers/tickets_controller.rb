class TicketsController < ApplicationController
	include TicketsHelper

	def index
		@tickets = all_tickets.parsed_response

		if @tickets.key?("error")
			flash[:notice] = @tickets["error"]
			redirect_to "/"
		end
	end

	def new
		if session[:user_email].nil?
			flash[:notice] = "You must set your email first!"
			redirect_to "/"
		end
	end

	def show
		@ticket = show_ticket

		if @ticket.key?("error")
			flash[:notice] = @ticket["error"]
			redirect_to "/"
		end
	end

	def create
		@ticket = create_ticket
		flash[:notice] = "Error: #{@ticket["error"]}" if @ticket.key?("error")

		redirect_to "/tickets/new"
	end
end
