$(function() {
  $('.table__row').on('click', 'td:not(.no-link)', function(){
        window.location = $(event.target).closest("tr").data("url");
    });
});

$(function(){
    $("input[type='checkbox']").on('change', function() {
        $(this).closest('tr').toggleClass("highlight", this.checked);
    });
});


$(function () {
  $("#check_all").click(function () {
     $('input:checkbox').not(this).prop('checked', this.checked);
     $('input:checkbox').not(this).closest('tr').toggleClass("highlight", this.checked);
 });
});