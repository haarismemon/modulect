module SessionsHelper

	# Logs in the given user.
	def log_in(user)
		session[:user_id] = user.id
		session[:last_login_time] = user.last_login_time
		user.update_attribute(:last_login_time, Time.now)
	end

	# Remembers a user in a persistent session.
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	# Forget a user from their persistent session.
	def forget(user)
		if user
			user.forget
			cookies.delete(:user_id)
			cookies.delete(:remember_token)
		end
	end


	# Returns the current logged in user.
	def current_user
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(:remember, cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end

	def current_user_last_login_time
		session[:last_login_time] 
	end

	def admin_user
		current_user && (current_user.user_level == "super_admin_access" || current_user.user_level == "department_admin_access")
	end

	# Logs out a user.
	def log_out
		forget current_user
		session.delete(:user_id)
		@current_user = nil
	end

	# Returns true if the user is logged in, false otherwise.
	def logged_in?
		!current_user.nil?
	end

	# Returns true if the user to check is the same as the user currently
	# logged in; false otherwise
	def current_user?(user)
		user == current_user
	end

	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	def store_location
		session[:forwarding_url] = request.original_url if request.get?
	end
end