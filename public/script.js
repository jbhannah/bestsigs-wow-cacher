"#character_form".onSubmit(function(event) {
  event.stop();
  this.send({
    onSuccess: function() {
      $('msg').update(this.responseText);
    }
  });
});
