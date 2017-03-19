<% if @chart_type == "table" %>
	$("#table_area").empty().append("<h4>Frequently chosen with <%= @uni_module.name %></h4>").append("<%= escape_javascript(render "table", input_hash: get_modules_chosen_with(@uni_module.id, @department, @course.id, 1, @time_period, Time.now, "most", 5)) %>")
<% elsif @chart_type == "vBar" %>
	$("#table_area").empty().append("<h4>Frequently chosen with <%= @uni_module.name %></h4>").append("<%= escape_javascript(render "chart", input_hash: get_modules_chosen_with(@uni_module.id, @department, @course.id, 1, @time_period, Time.now, "most", 5), type: 'bar') %>")
<% elsif @chart_type == "hBar" %>
  $("#table_area").empty().append("<h4>Frequently chosen with <%= @uni_module.name %></h4>").append("<%= escape_javascript(render "chart", input_hash: get_modules_chosen_with(@uni_module.id, @department, @course.id, 1, @time_period, Time.now, "most", 5), type: 'horizontalBar') %>")
<% elsif @chart_type == "pie" %>
  $("#table_area").empty().append("<h4>Frequently chosen with <%= @uni_module.name %></h4>").append("<%= escape_javascript(render "chart", input_hash: get_modules_chosen_with(@uni_module.id, @department, @course.id, 1, @time_period, Time.now, "most", 5), type: 'pie') %>")
<% end %>