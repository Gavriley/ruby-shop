  $(".top-bar > ul > li > a").hover(
    function() {
      $(this).animate({'color': '#01a161', 'background-color': '#dcdbdb'}, 320);
    },
    function() {
      $(this).animate({'color': '#fff', 'background-color': '#363636'}, 320);
    }
  );  

  $("#search").focus(
    function() {
      $(this).animate({'width': '300px'}, 500, function() {
        if($('.search-results').html() != '') {
          $("#search").css('border-radius', '5px 5px 0px 0px');
          $('.search-results').css('display', 'block');
        }  
      });
    }
  );

  $("#search").blur(
    function() {
      $(this).animate({'width': '200px'}, 500);
      $("#search").css('border-radius', '5px');
      $('.search-results').css('display', 'none');
    }
  );

  $(".search-results").mousedown(function(event){
    event.preventDefault();
  });

  $("#search").keyup(
    function(event) {
      var data = { search: event.target.value }

      $.ajax({
        type: 'POST',
        dataType: "json",
        data: data,
        url: '/products/search',
        success: function(result) {
          if(result['query']) {
            $("#search").css('border-radius', '5px 5px 0px 0px');
            $('.search-results').html(result['query']);
            $('.search-results').css('display', 'block');
          }else {
            $("#search").css('border-radius', '5px');
            $('.search-results').css('display', 'none');
          }  
        }
      });
    }
  );