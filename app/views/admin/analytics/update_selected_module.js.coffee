<% if @chart_type == "table" %>
	$("#table_area").empty().append("<%= escape_javascript(render "table", input_hash: get_modules_chosen_with(@uni_module.id, @department, @course.id, 1, @time_period, Time.now, "most", 5)) %>")
<% elsif @chart_type == "vBar" %>
	$("#table_area").empty().append("<%= escape_javascript(render "vbar", input_hash: get_modules_chosen_with(@uni_module.id, @department, @course.id, 1, @time_period, Time.now, "most", 5)) %>")
<% end %>