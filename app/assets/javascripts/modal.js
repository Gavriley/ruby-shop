if($('#modal_block')) {
  
  $(window).click(function(event) {
    if(event.target.id == 'modal') close_modal();
  });

  function close_modal() {
    $('#modal_block').html("");
  } 
}

