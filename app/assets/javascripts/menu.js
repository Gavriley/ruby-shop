// var active_li = sessionStorage.active_li; 
// var active_ul = sessionStorage.active_ul;

var active_listener = undefined; 
var active_nested_list = undefined;

if(sessionStorage.active_cat !== undefined) {
  
  active_listener = $('#listener_' + sessionStorage.active_cat);
  active_nested_list = $('#nested_list_' + sessionStorage.active_cat);
  
  categoryListener(active_listener, active_nested_list, sessionStorage.active_cat, false);
}


$('#category_list').click(function(event) {
  var element = $(event.target); 

  if(element.attr('class') != 'float-category') return true;

  var cat_id = element.attr('value');
  
  categoryListener($('#listener_' + cat_id), $('#nested_list_' + cat_id), cat_id, true);
});

function categoryListener(listener, nested_list, cat_id, click) {

  if(listener.is(active_listener) && click) {
    listener.html('[+]');
    nested_list.css('display', 'none');

    active_listener = undefined; 
    active_nested_list = undefined;

    sessionStorage.active_cat = undefined;
  }else {
    if(active_listener == undefined && active_nested_list == undefined) {
      active_listener = listener;
      active_nested_list = nested_list;

      sessionStorage.active_cat = cat_id;

      active_listener.html('[-]');
      active_nested_list.css('display', 'block');
    }else {
      active_listener.html('[+]');
      active_nested_list.css('display', 'none');

      active_listener = listener;
      active_nested_list = nested_list;

      sessionStorage.active_cat = cat_id;

      active_listener.html('[-]');
      active_nested_list.css('display', 'block');
    }
  }
}