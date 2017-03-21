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
=begin
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil? && course_id != "any" && is_number?(course_id) && !Course.find(course_id.to_i).nil?
			uni_modules = UniModule.all.select { |uni_module| uni_module.departments.include?(Department.find(department_id.to_i)) && check_mod_in_course(uni_module.id, course_id) }
		elsif department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			uni_modules = UniModule.all.select { |uni_module| uni_module.departments.include?(Department.find(department_id.to_i))}
		else
			uni_modules = UniModule.all
		end
		uni_modules
=end
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

	# get percentage difference
	# if negative output, then a decrease else increase
	def percentage_difference(new_value, old_value)
		increase = new_value.to_f - old_value.to_f
		percentage_change = (increase / old_value.to_f) * 100
		if percentage_change.nan?
			0.round(2)
		else 
			percentage_change.round(2)
		end
	end

	# used to colour percentage changes
	def colour(input_number)
		if input_number < 0
			"red"
		elsif input_number > 0
			"green"
		else 
			""
		end
	end

	# used to display indicator percentage changes
	def indicator(input_number)
		if input_number < 0
			"down"
		elsif input_number > 0
			"up"
		else 
			""
		end
	end

	# make time periods look nicer
	def format_time_period(time_period_string, add_this, add_past)
		if time_period_string == "all_time"
			"all time"
		elsif time_period_string == "day" 
			if add_this
				"24 hours"
			elsif add_past
				"past 24 hours"
			end
		else 
			if add_this
				"this " + time_period_string.titleize.downcase
			elsif add_past
				"past " + time_period_string.titleize.downcase
			end
		end
	end

	# get the start date of the desired period of time
	def get_start_desired_period(amount_time, time_period, from_date)
		if time_period == "hour"
			from_date - amount_time.hour
		elsif time_period == "day"
			from_date - amount_time.day
		elsif time_period == "week"
			from_date - amount_time.week
		elsif time_period == "month"
			from_date - amount_time.month
		elsif time_period == "year"
			from_date - amount_time.year
		elsif time_period == "all_time"
			from_date - 20.year
		end
	end

	# check whether the input (created_at) falls in the desired period of time
	def date_check(amount_time, time_period, from_date, created_at)
		created_at >= get_start_desired_period(amount_time, time_period, from_date) && created_at < from_date
	end


	# actual data mining:
	# generally the idea is to set up a hash of object => counter
	# and sort based on the counter

	# time period: day, week, month, year, all_time
	# sort by: most, least
	# number to show: how many records to retrieve
	# end date: for example, having month with end date of 31st january, should show the month of january

	# most/least reviewed modules



	def get_review_modules_analytics(uni_modules, amount_time, time_period, from_date, sort_by, number_to_show)

		uni_modules_data = Hash.new

		uni_modules.each do |uni_module|
			uni_module.comments.each do |comment|
				if User.exists?(comment.user_id) && User.find(comment.user_id).user_level == "user_access" && date_check(amount_time, time_period, from_date, comment.created_at)
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
	def get_rating_modules_analytics(uni_modules, amount_time, time_period, from_date, sort_by, number_to_show)

		uni_modules_data = Hash.new
					
		uni_modules.each do |uni_module|
			uni_module.comments.each do |comment|
			if User.exists?(comment.user_id) && User.find(comment.user_id).user_level == "user_access" && date_check(amount_time, time_period, from_date, comment.created_at)
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
	def get_active_courses(users, amount_time, time_period, from_date, sort_by, number_to_show)
		courses_data = Hash.new

		users.each do |user|
			if user.course_id.present?
				course = Course.find(user.course_id)
				if !user.last_login_time.nil? && date_check(amount_time, time_period, from_date, user.last_login_time)
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
	def get_active_departments(amount_time, time_period, from_date, sort_by, number_to_show)
		departments_data = Hash.new

		users.each do |user|
			if user.department_id.present?
				department = Department.find(user.department_id)
				if !user.last_login_time.nil? && date_check(amount_time, time_period, from_date, user.last_login_time)
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
	def get_active_departments_admin_wise(users, amount_time, time_period, from_date, sort_by, number_to_show)
		departments_data = Hash.new
		users =  users.select{ |user| user.user_level == "department_admin_access"}

		users.each do |user|
			department = Department.find(user.department_id)
			if !user.last_login_time.nil? && date_check(amount_time, time_period, from_date, user.last_login_time)
				if departments_data.key?(department)
					departments_data[department] += 1
				else
					departments_data[department] = 1
				end	
			end
		end

		format_ouput_data(departments_data, sort_by, number_to_show)

	end

	# most/least active users by number of saved
	def get_active_user(users, amount_time, time_period, from_date, sort_by, number_to_show)
		users_data = Hash.new

		users.each do |user|
			if user.uni_modules.size > 0
				user.uni_modules.each do |uni_module|
					if date_check(amount_time, time_period, from_date, SavedModule.where(:user_id => user.id, :uni_module_id => uni_module.id).first.created_at)
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

	# most/least saved modules
	def get_saved_modules(uni_modules, users, amount_time, time_period, from_date, sort_by, number_to_show)
		uni_modules_data = Hash.new
				
		users.each do |user|
			if user.uni_modules.size > 0
				user.uni_modules.each do |uni_module|
					if uni_modules.include?(uni_module) && date_check(amount_time, time_period, from_date, SavedModule.where(:user_id => user.id, :uni_module_id => uni_module.id).first.created_at)
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

	# most/least clicked modules
	def get_visited_modules(uni_modules, amount_time, time_period, from_date, sort_by, number_to_show)
		uni_modules_data = Hash.new

		UniModuleLog.all.each do |log|
			if UniModule.find(log.uni_module_id)
				uni_module = UniModule.find(log.uni_module_id)
				if uni_modules.include?(uni_module) && date_check(amount_time, time_period, from_date, log.created_at)
						uni_modules_data[uni_module] = log.counter
				end
			end
		end

		format_ouput_data(uni_modules_data, sort_by, number_to_show)
	end

	# get modules most frequently chosen with a selected module
	def get_modules_chosen_with(uni_module_id, department_id, course_id, amount_time, time_period, from_date, sort_by, number_to_show)
		uni_modules_data = Hash.new
		uni_modules = get_uni_modules(department_id, course_id)
		pathway_search_log_first_data = PathwaySearchLog.where("first_mod_id = ?", uni_module_id)
		pathway_search_log_second_data = PathwaySearchLog.where("second_mod_id = ?", uni_module_id)
    pathway_search_log_first_data.each do |log|
      if UniModule.find(log.second_mod_id)
        uni_module = UniModule.find(log.second_mod_id)
        if date_check(amount_time, time_period, from_date, log.created_at)
          uni_modules_data[uni_module] = log.counter
        end
      end
    end

    pathway_search_log_second_data.each do |log|
      if UniModule.find(log.first_mod_id)
        uni_module = UniModule.find(log.first_mod_id)
        if date_check(amount_time, time_period, from_date, log.created_at)
          uni_modules_data[uni_module] = log.counter
        end
      end
    end

    format_ouput_data(uni_modules_data, sort_by, number_to_show)

    p format_ouput_data(uni_modules_data, sort_by, number_to_show)

  end

	# most/least clicked (trending) tags
	def get_clicked_tags(department_id, amount_time, time_period, from_date, sort_by, number_to_show)
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			departments = [Department.find(department_id.to_i)]
		else
			departments = Department.all
		end

		all_uni_modules = []
		departments.each do |department|
			all_uni_modules.concat get_uni_modules(department.id.to_s, "any")
		end
		all_uni_modules = all_uni_modules.uniq{|uni_module| uni_module.id}
		

		all_tags = []
		all_uni_modules.each do |uni_module|
			all_tags.concat uni_module.tags
		end
		all_tags = all_tags.uniq{|tag| tag.id}

		tags_data = Hash.new
		TagLog.all.each do |log|
			if Tag.find(log.tag_id)
				tag = Tag.find(log.tag_id)
				if all_tags.include?(tag) && date_check(amount_time, time_period, from_date, log.created_at)
						tags_data[tag] = log.counter
				end
			end
		end

		# then sort based on request
		if sort_by == "least"
			tags_data = tags_data.sort_by {|_key, value| value}
		elsif
			tags_data = tags_data.sort_by {|_key, value| value}.reverse
		end

		if is_number?(number_to_show)
			tags_data = tags_data.first(number_to_show)
		end
		tags_data

	end

	# most/least clicked (trending) tags
	def get_clicked_career_tags(department_id, amount_time, time_period, from_date, sort_by, number_to_show)
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			departments = [Department.find(department_id.to_i)]
		else
			departments = Department.all
		end

		all_uni_modules = []
		departments.each do |department|
			all_uni_modules.concat get_uni_modules(department.id.to_s, "any")
		end
		all_uni_modules = all_uni_modules.uniq{|uni_module| uni_module.id}
		

		all_tags = []
		all_uni_modules.each do |uni_module|
			all_tags.concat uni_module.career_tags
		end
		all_tags = all_tags.uniq{|tag| tag.id}

		tags_data = Hash.new
		TagLog.all.each do |log|
			if Tag.find(log.tag_id)
				tag = Tag.find(log.tag_id)
				if all_tags.include?(tag) && date_check(amount_time, time_period, from_date, log.created_at)
						tags_data[tag] = log.counter
				end
			end
		end

		# then sort based on request
		if sort_by == "least"
			tags_data = tags_data.sort_by {|_key, value| value}
		elsif
			tags_data = tags_data.sort_by {|_key, value| value}.reverse
		end

		if is_number?(number_to_show)
			tags_data = tags_data.first(number_to_show)
		end
		tags_data

	end

	# most/least clicked (trending) tags
	def get_clicked_interest_tags(department_id, amount_time, time_period, from_date, sort_by, number_to_show)
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			departments = [Department.find(department_id.to_i)]
		else
			departments = Department.all
		end

		all_uni_modules = []
		departments.each do |department|
			all_uni_modules.concat get_uni_modules(department.id.to_s, "any")
		end
		all_uni_modules = all_uni_modules.uniq{|uni_module| uni_module.id}
		

		all_tags = []
		all_uni_modules.each do |uni_module|
			all_tags.concat uni_module.interest_tags
		end
		all_tags = all_tags.uniq{|tag| tag.id}

		tags_data = Hash.new
		TagLog.all.each do |log|
			if Tag.find(log.tag_id)
				tag = Tag.find(log.tag_id)
				if all_tags.include?(tag) && date_check(amount_time, time_period, from_date, log.created_at)
						tags_data[tag] = log.counter
				end
			end
		end

		# then sort based on request
		if sort_by == "least"
			tags_data = tags_data.sort_by {|_key, value| value}
		elsif
			tags_data = tags_data.sort_by {|_key, value| value}.reverse
		end

		if is_number?(number_to_show)
			tags_data = tags_data.first(number_to_show)
		end
		tags_data

	end

	# get number of visitors (both logged in and non-logged in)
	def get_number_visitors(department_id, amount_time, time_period, from_date)

		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			logs = VisitorLog.all.select{|log| log.department_id == department_id.to_i}
		else
			logs = VisitorLog.all
		end


		total_visitors = 0
		
		logs.each do |log|
			if date_check(amount_time, time_period, from_date, log.created_at)
				total_visitors += 1
			end
		end

		total_visitors

	end

	# get number of logged in users
	def get_number_logged_in_users(department_id, amount_time, time_period, from_date)
		
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			logs = VisitorLog.all.select{|log| log.department_id == department_id.to_i}
		else
			logs = VisitorLog.all
		end


		total_visitors = 0
		
		logs.each do |log|
			if date_check(amount_time, time_period, from_date, log.created_at) && log.logged_in
				total_visitors += 1
			end
		end

		total_visitors
	end

  def get_login_analytics(department_id, amount_time, time_period, from_date)
    data = Hash.new
    logged_in = get_number_logged_in_users(department_id, amount_time, time_period, from_date)
    not_logged_in = get_number_visitors(department_id, amount_time, time_period, from_date) - logged_in

    data["Logged In"] = logged_in
    data["Not Logged In"] = not_logged_in

    data
  end

	# get device usage
	def get_device_usage(department_id, amount_time, time_period, from_date)
		
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			logs = VisitorLog.all.select{|log| log.department_id == department_id.to_i}
		else
			logs = VisitorLog.all
		end


		devices = Hash.new
		
		logs.each do |log|
			if  date_check(amount_time, time_period, from_date, log.created_at)
				if devices.key?(log.device_type)
					devices[log.device_type] += 1
				else
					devices[log.device_type] = 1
				end
			end
		end

		devices

	end

	# get number quick searches
	def get_number_quick_searches(department_id, amount_time, time_period, from_date)
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			logs = SearchLog.all.select{|log| log.department_id == department_id.to_i && log.search_type == "quick"}
		else
			logs = SearchLog.all.select{|log| log.search_type == "quick"}
		end


		total_searches = 0
		
		logs.each do |log|
			if  date_check(amount_time, time_period, from_date, log.created_at)
				total_searches += log.counter
			end
		end

		total_searches
	end

	# get number pathway searches(department_id, time_period, end_date)
	def get_number_pathway_searches(department_id, amount_time, time_period, from_date)
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			logs = SearchLog.all.select{|log| log.department_id == department_id.to_i && log.search_type == "pathway"}
		else
			logs = SearchLog.all.select{|log| log.search_type == "pathway"}
		end


		total_searches = 0
		
		logs.each do |log|
			if date_check(amount_time, time_period, from_date, log.created_at)
				total_searches += log.counter
			end
		end

		total_searches
	end

	# get number career searches
	def get_number_career_searches(department_id, amount_time, time_period, from_date)
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			logs = SearchLog.all.select{|log| log.department_id == department_id.to_i && log.search_type == "career"}
		else
			logs = SearchLog.all.select{|log| log.search_type == "career"}
		end


		total_searches = 0
		
		logs.each do |log|
			if  date_check(amount_time, time_period, from_date, log.created_at)
				total_searches += log.counter
			end
		end

		total_searches

	end

	# return search logs
	def get_search_lists(department_id, type, amount_time, time_period, from_date)
		if department_id != "any" && is_number?(department_id) && !Department.find(department_id.to_i).nil?
			logs = SearchLog.all.select{|log| log.department_id == department_id.to_i && log.search_type == type}
		else
			logs = SearchLog.all.select{|log| log.search_type == type}
		end

		logs.select{|log| date_check(amount_time, time_period, from_date, log.created_at)}
	end

	# e.g. 17:00 18:00 19:00 20:00 21:00 22:00 23:00 00:00 01:00 02:00 03:00 04:00 05:00 06:00 07:00 08:00 09:00 10:00 11:00 12:00 13:00 14:00 15:00 16:00 17:00 
	# Friday 10 Saturday 11 Sunday 12 Monday 13 Tuesday 14 Wednesday 15 Thursday 16 Friday 17 
	# March ('16) April ('16) May ('16) June ('16) July ('16) August ('16) September ('16) October ('16) November ('16) December ('16) January ('17) February ('17) March ('17) 2012 2013 2014 2015 2016 2017
	def get_list_of_time_periods(time_period)
		toReturn = []
		if time_period == "day"
			24.downto(0) do |i|
				toReturn << i.hours.ago.strftime("%a %d %H:00")
			end
		elsif time_period == "week"
			7.downto(0) do |i|
				toReturn << i.days.ago.strftime("%A %d")
			end
		elsif  time_period == "month"
			31.downto(0) do |i|
				toReturn << i.days.ago.strftime("%b %d")
			end
		elsif  time_period == "year"
			12.downto(0) do |i|
				toReturn << i.months.ago.strftime("%B ('%y)")
			end
		elsif time_period == "all_time"
			3.downto(0) do |i|
				toReturn << i.years.ago.strftime("%Y")
			end		
		end

		toReturn
	end

	# attaches search log date to atime period by normalising both hashes and comparing the different time periods
	def attach_search_log_data_to_time_period(data_log, time_period)

		data_with_time = Hash.new

		get_list_of_time_periods(time_period).each do |time|
			data_with_time[time] = 0
		end

		if time_period == "day"
			data_log.each do |log|
				hour = log.created_at.strftime("%a %d %H:00")
				data_with_time[hour] = data_with_time[hour] + log.counter
			end
		elsif time_period == "week"
			data_log.each do |log|
				day = log.created_at.strftime("%A %d")
				data_with_time[day] = data_with_time[day] + log.counter
			end
		elsif  time_period == "month"
			data_log.each do |log|
				day = log.created_at.strftime("%b %d")
				data_with_time[day] = data_with_time[day] + log.counter
			end
		elsif  time_period == "year"
			data_log.each do |log|
				month = log.created_at.strftime("%B ('%y)")
				data_with_time[month] = data_with_time[month] + log.counter
			end
		elsif time_period == "all_time"
			data_log.each do |log|
				year = log.created_at.strftime("%Y")
				data_with_time[year] = data_with_time[year] + log.counter
			end
		end

		data_to_return = []

		data_with_time.each do |time, data|
			data_to_return << data
		end

		data_to_return
	end


	# a simple size checker
	def get_top_size_check_analytics(input_hash)
		if input_hash.size == 0
			"(None)"
		else
			input_hash.first.first
		end
	end

	# a simple size checker
	def get_top_module_name(input)
		if input == "(None)"
			"(None)"
		else
			input.name
		end
	end



	def get_top_module_code(input)
		if input == "(None)"
			"(None)"
		else
			input.code
		end
	end


end