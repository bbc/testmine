function loadComparisons() {
  
  var elements = $('.comparison-loader')
  for ( var i=0; i < elements.length; i++ ) {
    loadComparison(elements[i].id)
  }
}


function loadComparison(id)
{
    var elems = id.split("-");
    elems.shift();
    var primary_id = elems.shift();
    var reference_id = elems.shift();
    var test_definition_id = elems.shift();
    var target = elems.join('-');
    
    $.ajax({ url: '/comparison/'+primary_id+'/'+reference_id+'?test='+test_definition_id+'&target='+target,
             type: 'GET',
             success: function( data ) {
                $('[id="' + id + '"]').replaceWith(data);
             }
           })
}

function loadAggregates() {
  
  var elements = $('.aggregate-loader')
  for ( var i=0; i < elements.length; i++ ) {
    loadAggregate(elements[i].id)
  }
}


function loadAggregate(id)
{
    var elems = id.split("-");
    elems.shift();
    var world_id = elems.shift();
    var test_definition_id = elems.shift();
    var target = elems.join('-');
    
    $.ajax({ url: '/aggregate/'+world_id+'?test='+test_definition_id+'&target='+target,
             type: 'GET',
             success: function( data ) {
                $('[id="' + id + '"]').replaceWith(data);
             }
           })
}