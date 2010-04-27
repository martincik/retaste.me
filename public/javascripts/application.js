$(document).ready(function(){

	divs = "#flash_success, #flash_notice, #flash_error"
  $(divs).slideDown(function() {
    $(divs).oneTime(2500, function() {
      $(this).slideUp();
    });
  });

});