$(document).ready(function() {
  $('.links').on('cocoon:after-insert', function(e, insertedItem) {
    insertedItem.find('.selectize').selectize({
        plugins: ['remove_button'],
        delimiter: ',',
        persist: false,
        create: false
    });
  });

  $('#select-departments > .selectize').selectize({
      plugins: ['remove_button'],
      delimiter: ',',
      persist: false,
      create: false
  });

  $('#select-modules-from-group-form > .selectize').selectize({
      plugins: ['remove_button'],
      delimiter: ',',
      persist: false,
      create: false
  });
});
