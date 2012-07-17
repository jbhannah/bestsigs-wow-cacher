$(document).on('ready', function() {
  $('character_form').remotize({
    onSuccess: function() {
      $('msg').update(this.responseText);
    },
    onFailure: function() {
      $('msg').update("URL could not be generated!");
    }
  });
});
