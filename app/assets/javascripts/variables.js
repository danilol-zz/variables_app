$(document).on('page:change', function() {
  $("#variable_origin_fields").select2({
    placeholder: "pesquisa...",
    minimumInputLength: 2,
    multiple: true,
    width: "975px",
    initSelection : function (element, callback) {
      var id=$('#variable_id').val();
      if (id !== "") {
        $.ajax("/variable_origin_fields_search/" + id).done(function(data) {
          callback(data);
        })
      }
    },
    ajax: {
      url: "/origin_field_name_search.json",
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
              text: item.origin_file_field_name,
              id: item.id
            }
          })
        };
      }
    }
  });
});
