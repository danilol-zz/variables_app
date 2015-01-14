$(document).on('page:change', function() {
  $("#variables").select2({
    placeholder: "pesquisa...",
    minimumInputLength: 2,
    multiple: true,
    width: "975px",
    initSelection : function (element, callback) {
      var id=$('#table_id').val();
      if (id !== "") {
        $.ajax("/table_variables_search/" + id).done(function(data) {
          callback(data);
        })
      }
    },
    ajax: {
      url: "/variable_name_search.json",
      dataType: "json",
      data: function (term) {
        return {
          term: term
        };
      },
      results: function (data) {
        return {
          results: $.map(data, function (item) {
            return {
              text: item.name,
              id: item.id
            }
          })
        };
      }
    }
  });
});

