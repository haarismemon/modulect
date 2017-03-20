$ ->
 $(document).on 'change', '#courses_select', (evt) ->
    $.ajax 'update_modules',
      type: 'GET'
      dataType: 'script'
      data: {
        course_id: $("#courses_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic Course select OK!")

$ ->
  $(document).on 'change', '#modules_select', (evt) ->
      $.ajax 'update_selected_module',
        type: 'GET'
        dataType: 'script'
        data: {
          module_id: $("#modules_select option:selected").val()
          course_id: $("#courses_select option:selected").val()
          chart_type: $("#pathway-graph-selector option:selected").val()
        }

$ ->
  $(document).on 'change', '#pathway-graph-selector', (evt) ->
      $.ajax 'update_selected_module',
        type: 'GET'
        dataType: 'script'
        data: {
          module_id: $("#modules_select option:selected").val()
          course_id: $("#courses_select option:selected").val()
          chart_type: $("#pathway-graph-selector option:selected").val()
        }

$ ->
  $(document).on 'change', '#departments_select', (evt) ->
      $.ajax 'update_selected_department',
        type: 'GET'
        data: {
          module_id: $("#departments_select option:selected").val()
        }