function loadComparisonGroups(tag) {
  
  var elements = $('.comparison-loader')
  for ( var i=0; i < elements.length; i++ ) {
    loadComparisonGroup(elements[i].id, tag)
  }
}

function loadComparisonGroup(id, tag)
{
    var elems = id.split("-");
    elems.shift();
    var primary_id = elems.shift();
    var reference_id = elems.shift();
    var target = elems.join('-');
    
    $.ajax({ url: '/comparison/'+primary_id+'/'+reference_id+'?target='+target+'&tag='+tag,
             type: 'GET',
             success: function( data ) {
                $('[id="' + id + '"]').replaceWith(data);
             }
           })
}

function loadAggregateGroups(tag) {
  
  var elements = $('.aggregate-group-loader')
  for ( var i=0; i < elements.length; i++ ) {
    loadAggregateGroup(elements[i].id, tag)
  }
}

function loadAggregateGroup(id, tag)
{
    var elems = id.split("-");
    elems.shift();
    var world_id = elems.shift();
    var target = elems.join('-');
    
    $.ajax({ url: '/aggregate/'+world_id+'?target='+target+'&tag='+tag,
             type: 'GET',
             success: function( data ) {
                $('[id="' + id + '"]').replaceWith(data);
             }
           })
}