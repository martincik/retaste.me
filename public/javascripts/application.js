$(document).ready(function(){

  $("div.item h1 a.edit").addClass('unvisible');
  $("div.item h1 a.destroy").addClass('unvisible');
  $("div.item h2 a.edit").addClass('unvisible');
  $("div.item h2 a.destroy").addClass('unvisible');

  $("div.item h1").mouseover(function() {
    $(this).children('a.edit').removeClass('unvisible');
    $(this).children('a.destroy').removeClass('unvisible');
    return false;
  });

  $("div.item h2").mouseover(function() {
    $(this).children('a.edit').removeClass('unvisible');
    $(this).children('a.destroy').removeClass('unvisible');
    return false;
  });

  $("div.item h1").mouseout(function() {
   $(this).children('a.edit').addClass('unvisible');
   $(this).children('a.destroy').addClass('unvisible');
   return false;
  });
  
  $("div.item h2").mouseout(function() {
   $(this).children('a.edit').addClass('unvisible');
   $(this).children('a.destroy').addClass('unvisible');
   return false;
  });

	divs = "#flash_success, #flash_notice, #flash_error"
  $(divs).slideDown(function() {
    $(divs).oneTime(2500, function() {
      $(this).slideUp();
    });
  });
  
  $('#account-info :input').change(function() {
    $(this).parent().submit();
  })

});