function loadComparisons() {
  
  var elements = $('.comparison_loader')
  for ( var i=0; i < elements.length; i++ ) {
    loadComparison(elements[i].id)
  }
}


function loadComparison(id)
{
    var elems = id.split("-");
    var primary_id = elems[0];
    var reference_id = elems[1];
    var test_definition_id = elems[2];
    var target = elems[3];
    
    $.ajax({ url: '/comparison/'+primary_id+'/'+reference_id+'?test='+test_definition_id+'&target='+target,
             type: 'GET',
             success: function( data ) {
                $("#"+id).replaceWith(data);
             }
           })
    
    
}

