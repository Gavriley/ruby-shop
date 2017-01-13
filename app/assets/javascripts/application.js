// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui/effects/effect-blind
//= require jquery_ujs
//= require jquery.remotipart
//= require turbolinks

$(window).scroll(function() {
  if( window.scrollY < 40 ) {
    $(".sidebar").css('padding-top', '60px');
  }else {
    $(".sidebar").css('padding-top', '20px');
  }  
});

if($('.admin-bar-base')) $('.main-block ').css('margin', '20px auto');

$(function() {

  var faye = new Faye.Client('http://localhost:9292/faye');
  faye.subscribe("/clean_cart", function() {
    console.log('ok');
    $.ajax({
      type: 'POST',
      dataType: "json",
      url: '/carts/clean',
      success: function(result) {
        if($('#cart')) $('#cart').html(result['cart']);  
      }
    });
  });
});