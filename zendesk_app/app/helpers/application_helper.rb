module ApplicationHelper
	def set_session_email(email)
		session[:user_email] = email
	end
end
