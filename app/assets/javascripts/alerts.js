$( document ).on('turbolinks:load', function() {
    if ($('.notice').length) {
      setTimeout(function() {
          hideNotification($('.notice'));
      }, 5000);
    }

    if ($('.alert').length) {
      setTimeout(function() {
          hideNotification($('.alert'));
      }, 5000);
    }

    function hideNotification(notification) {
      $(notification).fadeOut("slow");
    }
});
