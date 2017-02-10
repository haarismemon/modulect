var data = ["Amsterdam",
    "London",
    "Paris",
    "Washington",
    "New York",
    "Los Angeles",
    "Sydney",
    "Melbourne",
    "Canberra",
    "Beijing",
    "New Delhi",
    "Kathmandu",
    "Cairo",
    "Cape Town",
    "Kinshasa"];
var citynames = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    local: $.map(data, function (city) {
        return {
            name: city
        };
    })
});
citynames.initialize();

$('.category-container > > input').tagsinput({
    typeaheadjs: [{
          minLength: 3,
          highlight: true,
    },{
        minlength: 3,
        name: 'citynames',
        displayKey: 'name',
        valueKey: 'name',
        source: citynames.ttAdapter()
    }],
    freeInput: true
});