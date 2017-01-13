if($("#file_block")) {

  function readURL(input) {
    $("#info_block").html('');  
    $("#clear").css("display","block");
    $("#raper_file").css("display","none");
    if($("#drop_file")) $("#drop_file").remove();  
      
    if (input.files && input.files[0]) {
      var reader =  new FileReader();

      reader.onload = function (e) {
        $('#file_container').attr('src', e.target.result);
        $('#file_container').css("display","block");
      }

      reader.readAsDataURL(input.files[0]);
    }
  }


  $("#thumbnail").change(function() { 
         // console.log(this.files[0]);  
    var data = new FormData(); 
    var file = this;

    data.append('thumbnail', file.files[0]);

    $.ajax({
      type: 'POST',
      dataType: "json",
      data: data,
      url: '/products/valid_thumbnail',
      mimeType: "multipart/form-data",
      contentType: false,
      processData: false,
      success: function(result) {
        readURL(file);  
      },
      error: function(jqXHR, textStatus, errorThrown){
        $("#info_block").html(jQuery.parseJSON(jqXHR.responseText)['errors']);  
        $("#thumbnail").val("");
      }
    });
  });

  $("#avatar").change(function() { 
         // console.log('this.files[0]');  
    var data = new FormData(); 
    var file = this;

    data.append('avatar', file.files[0]);

    $.ajax({
      type: 'POST',
      dataType: "json",
      data: data,
      url: '/users/valid_avatar',
      mimeType: "multipart/form-data",
      contentType: false,
      processData: false,
      success: function(result) {
        readURL(file);  
      },
      error: function(jqXHR, textStatus, errorThrown){
        $("#info_block").html(jQuery.parseJSON(jqXHR.responseText)['errors']);  
        $("#avatar").val("");
      }
    });
  });

  $("#clear").click(function (e) {
    $("#file_container").css("display","none");
    $($(e.target).attr("for")).val("");
    $("#raper_file").css("display","block");
    $("#clear").css("display","none");
    $("#file_block").append("<input type='hidden' name='drop_file' id='drop_file'>");
    e.preventDefault();
  });
}