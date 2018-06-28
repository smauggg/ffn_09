$(document).ready(function(){
  $('#continent').change(function(){
    $.ajax({
      method: 'get',
      url: '/teams',
      data: {continent_id : $('#continent').val()},
      contentType: 'json',
      dataType: 'script'
    });
  });
});
