$ ->
 $(document).on 'change', '#faculties_select', (evt) ->
    $.ajax 'update_departments',
      type: 'GET'
      dataType: 'script'
      data: {
        faculty_id: $("#faculties_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic faculty select OK!")

$ ->
 $(document).on 'change', '#departments_select', (evt) ->
    $.ajax 'update_courses',
      type: 'GET'
      dataType: 'script'
      data: {
        department_id: $("#departments_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic department select OK!")