//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require cocoon
//= require_self
//= require admin-side/selectize.min
//= require moment
//= require datetime_picker
//= require_tree
//= require twitter/typeahead.min

function intializeSelectize() {

    $('.selectize').selectize({
        plugins: ['remove_button'],
        delimiter: ',',
        persist: false,
        create: false
    });
}


