$(function() {
  $('.table__row').on('click', 'td:not(.no-link)', function(){
        window.location = $(event.target).closest("tr").data("url");
    });
});

