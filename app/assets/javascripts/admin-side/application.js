//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require cocoon
//= require_self
//= require admin-side/selectize.min
//= require edit.js.coffee
//= require_tree
//= require twitter/typeahead.min
//= require tinymce


function intializeSelectize() {

    $('.selectize').selectize({
        plugins: ['remove_button'],
        delimiter: ',',
        persist: false,
        create: false
    });
}


