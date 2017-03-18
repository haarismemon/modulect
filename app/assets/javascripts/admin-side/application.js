//= require jquery
//= require jquery_ujs
//= require admin-side/moment.js
//= require bootstrap
//= require cocoon
//= require_self
//= require admin-side/selectize.min
//= require edit.js.coffee
//= require_tree
//= require twitter/typeahead.min
//= require tinymce
//= require admin-side/transition.js
//= require admin-side/collapse.js
//= require admin-side/bootstrap-datetimepicker.js


function intializeSelectize() {

    $('.selectize').selectize({
        plugins: ['remove_button'],
        delimiter: ',',
        persist: false,
        create: false
    });
}


