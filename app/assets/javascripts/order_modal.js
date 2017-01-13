if($('#order_block')) {

  $('#push_order').on('click', function(event) {
    $('#order_block').css("display","block");
    event.preventDefault();
  });

  $('#close').on('click', function(event) {
    $('#order_block').css("display","none");
    $("#info_block").html("");
    event.preventDefault();
  });

  $(window).click(function(event) {
    if(event.target.id == 'order_block') {
      $('#order_block').css("display","none");
      $("#info_block").html("");
    }
  });
}