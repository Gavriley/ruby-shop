var activeTab = $('#description_tab');
var activeBlock = $('#description_block');

$('#tabs').click(function(event) {
  var currentEvent = $(event.target);
  
  if((currentEvent.attr('class') != 'active') && (currentEvent.get(0).nodeName == 'SPAN')) {
    activeTab.removeClass('active');  
    activeBlock.css('display', 'none');

    activeTab = currentEvent;
    activeBlock = $('#' + activeTab.attr('for'));

    activeTab.addClass('active');
    activeBlock.css('display', 'block');

    // $(event.target.parentNode.parentNode).children().each(function() {
    //   var element = $(this).children().first();

    //   if(element.attr('class') == 'active') {
    //     element.removeClass('active');
    //     return false;
    //   }
    // });

    // $(event.target).addClass('active');
  }
}); 