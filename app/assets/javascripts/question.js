$(document).ready(function() {
    console.log( "readytogo!" );
    $('.question-form').hide();
    $('.cancel-link').hide();

    $('.edit-question-link, .cancel-link').click(function(){
        $('.question-title').toggle();
        $('.question-body').toggle();
        $('.form-container').toggle();
        $('.edit-question-link').toggle();
        $('.cancel-link').toggle();
        $('.form-container form')[0].reset();
    });

    $('form.edit_question').bind('ajax:success',
      function(e, data, status, xhr) {
          $('#errors').html('');
          if (data.status_ok) {
              $('.question-title').html(data.question.title);
              $('.question-body').html(data.question.body);
              $('.question-title').show();
              $('.question-body').show();
              $('.form-container').toggle();
              $('.edit-question-link').show();
              $('.cancel-link').hide();
          } else {
              $.each(data.errors, function(index, message) {
                  $('#errors').append(message + "<br>");
              })
          }
      });
});