$(document).ready(function() {
  $('.links').on('cocoon:after-insert', function(e, insertedItem) {
    insertedItem.find('.selectize').selectize({});
  });

  $('#select-departments > .selectize').selectize({});

  $('#select-modules-from-group-form > .selectize').selectize({});
});
