module AnalyticsHelper

	# general helpers:

	# check if the input is a number
	def is_number? string
  		true if Float(string) rescue false
	end

	# get the student users from the department
	# if "any", return all users
	def get_users(department_id)
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			users = User.all.select { |user| user.department_id == department_id.to_i && user.user_level == "user_access"}
		else
			users = User.all.select { |user| user.user_level == "user_access"}
		end
		users 
	end

	# get all the unimodules from department / course
	# if "any", return all
	def get_uni_modules(department_id, course_id)
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil? && course_id != "any" && is_number?(course_id) && !Course.find(course_id.to_i).nil?
			uni_modules = UniModule.all.select { |uni_module| uni_module.departments.include?(Department.find(department_id.to_i)) && uni_module.courses.include?(Course.find(course_id.to_i))}
		elsif department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			uni_modules = UniModule.all.select { |uni_module| uni_module.departments.include?(Department.find(department_id.to_i))}
		else
			uni_modules = UniModule.all
		end
		uni_modules
	end

	# get the difference in the number of days between two dates
	# earlier_date < later_date
	def get_day_difference(later_date, earlier_date)
		(later_date.to_date - earlier_date.to_date).to_i
	end

	# check whether the difference in days is within the timeframe
	def is_within_timeframe?(diffence_days, time_period)
		time_periods = Hash.new
		time_periods["day"] = 1
		time_periods["week"] = 7
		time_periods["month"] = 30
		time_periods["year"] = 365
		time_periods["all_time"] = (2**(0.size * 8 -2) -1)

		if diffence_days <= time_periods[time_period]	
			true
		else
			false
		end

	end

	# sort, filter and format the resulting dataset
	def format_ouput_data(input_hash, sort_by, number_to_show)
		# sort alphabetically
		input_hash = input_hash.sort_by {|_key, value| _key}

		# then sort based on request
		if sort_by == "least"
			input_hash = input_hash.sort_by {|_key, value| value}
		elsif
			input_hash = input_hash.sort_by {|_key, value| value}.reverse
		end

		if is_number?(number_to_show)
			input_hash = input_hash.first(number_to_show)
		end
		input_hash
	end

	# actual data mining:
	# generally the idea is to set up a hash of object => counter
	# and sort based on the counter

	# time period: day, week, month, year, all_time
	# sort by: most, least
	# number to show: how many records to retrieve
	# end date: for example, having month with end date of 31st january, should show the month of january

	# most/least reviewed modules
	def get_review_modules_analytics(department_id, course_id, time_period, end_date, sort_by, number_to_show)

		uni_modules_data = Hash.new
		uni_modules = get_uni_modules(department_id, course_id)

		uni_modules.each do |uni_module|
			uni_module.comments.each do |comment|
				if User.exists?(comment.user_id) && User.find(comment.user_id).user_level == "user_access" && is_within_timeframe?(get_day_difference(end_date, comment.created_at), time_period)
					uni_module = comment.uni_module
					if uni_modules.include?(uni_module)
						if uni_modules_data.key?(uni_module)
							uni_modules_data[uni_module] += 1
						else
							uni_modules_data[uni_module] = 1
						end
					end
				end
			end
		end
		
		format_ouput_data(uni_modules_data, sort_by, number_to_show)
	end

	# most/least highly rated modules
	def get_rating_modules_analytics(department_id, course_id, time_period, end_date, sort_by, number_to_show)

		uni_modules_data = Hash.new
		uni_modules = get_uni_modules(department_id, course_id)
					
		uni_modules.each do |uni_module|
			uni_module.comments.each do |comment|
			if User.exists?(comment.user_id) && User.find(comment.user_id).user_level == "user_access" && is_within_timeframe?(get_day_difference(end_date, comment.created_at), time_period)
				uni_module = comment.uni_module
				if uni_modules.include?(uni_module)
					if uni_modules_data.key?(uni_module)
						uni_modules_data[uni_module] += comment.rating
						else
							uni_modules_data[uni_module] = comment.rating
						end
					end
				end
			end
		end
			

		# get average ratings
		uni_modules_data.each do |uni_module, counter|
			uni_modules_data[uni_module] = counter / uni_module.comments.select{ |comment| User.exists?(comment.user_id) && User.find(comment.user_id).user_level == "user_access"}.size.to_f
		end

		format_ouput_data(uni_modules_data, sort_by, number_to_show)
	end

	# most/least active courses
	def get_active_courses(department_id, time_period, end_date, sort_by, number_to_show)
		courses_data = Hash.new
		users = get_users(department_id)

		users.each do |user|
			if user.course_id.present?
				course = Course.find(user.course_id)
				if !user.last_login_time.nil? && is_within_timeframe?(get_day_difference(end_date, user.last_login_time), time_period)
					if courses_data.key?(course)
						courses_data[course] += 1
					else
						courses_data[course] = 1
					end	
				end
			end
		end

		format_ouput_data(courses_data, sort_by, number_to_show)
	end

	# most/least active department
	def get_active_departments(time_period, end_date, sort_by, number_to_show)
		departments_data = Hash.new
		users = get_users("any")

		users.each do |user|
			if user.department_id.present?
				department = Department.find(user.department_id)
				if !user.last_login_time.nil? && is_within_timeframe?(get_day_difference(end_date, user.last_login_time), time_period)
					if departments_data.key?(department)
						departments_data[department] += 1
					else
						departments_data[department] = 1
					end	
				end
			end
		end

		format_ouput_data(departments_data, sort_by, number_to_show)

	end

	# most/least active department (admin-wise)
	def get_active_departments_admin_wise(time_period, end_date, sort_by, number_to_show)
		departments_data = Hash.new
		users =  User.all.select{ |user| user.user_level == "department_admin_access"}

		users.each do |user|
			department = Department.find(user.department_id)
			if !user.last_login_time.nil? && is_within_timeframe?(get_day_difference(end_date, user.last_login_time), time_period)
				if departments_data.key?(department)
					departments_data[department] += 1
				else
					departments_data[department] = 1
				end	
			end
		end

		format_ouput_data(departments_data, sort_by, number_to_show)

	end

	# most/least active users by number of saves
	def get_active_user_by_saves(department_id, time_period, end_date, sort_by, number_to_show)
		users_data = Hash.new
		users = get_users(department_id)

		users.each do |user|
			if user.uni_modules.size > 0
				user.uni_modules.each do |uni_module|
					if is_within_timeframe?(get_day_difference(end_date, SavedModule.where(:user_id => user.id, :uni_module_id => uni_module.id).first.created_at), time_period)
						if users_data.key?(user)
							users_data[user] += 1
						else
							users_data[user] = 1
						end	
					end
				end
			end
		end


		format_ouput_data(users_data, sort_by, number_to_show)

	end

	# most/least active users by number of searches
	def get_active_user_by_comments(department_id, time_period, end_date, sort_by, number_to_show)
		users_data = Hash.new
		users = get_users(department_id)

		users.each do |user|
			if user.comments.size > 0
				user.comments.each do |comment|
					if is_within_timeframe?(get_day_difference(end_date, comment.created_at), time_period)
						if users_data.key?(user)
							users_data[user] += 1
						else
							users_data[user] = 1
						end	
					end
				end
			end
		end


		format_ouput_data(users_data, sort_by, number_to_show)

	end

	# most/least active users by number of comments
	def get_active_user_by_searches
		# TO DO
	end

	# most/least saved modules
	def get_saved_modules
		# TO DO
	end

	# most/least clicked tags
	def get_visited_modules
		# TO DO
	end

	# most/least clicked (trending) tags
	def get_most_clicked_tags
		# TO DO
	end

	# get number of visitors (both logged in and non-logged in)
	def get_number_visitors(department_id, time_period, end_date)

		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			logs = VisitorLog.all.select{|log| log.department_id == department_id.to_i}
		else
			logs = VisitorLog.all
		end


		total_visitors = 0
		
		logs.each do |log|
			if is_within_timeframe?(get_day_difference(end_date, log.created_at), time_period)
				total_visitors += 1
			end
		end

		total_visitors

	end

	# get number of logged in users
	def get_number_logged_in_users(department_id, time_period, end_date)
		
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			logs = VisitorLog.all.select{|log| log.department_id == department_id.to_i}
		else
			logs = VisitorLog.all
		end


		total_visitors = 0
		
		logs.each do |log|
			if is_within_timeframe?(get_day_difference(end_date, log.created_at), time_period) && log.logged_in
				total_visitors += 1
			end
		end

		total_visitors
	end

	# get device usage
	def get_device_usage
		# TO DO
	end

	# get number quick searches
	def get_number_quick_searches
		# TO DO
	end

	# get number pathway searches
	def get_number_pathway_searches
		# TO DO
	end

	# get number career searches
	def get_number_career_searches
		# TO DO
	end



end