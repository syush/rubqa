function question_toggle() {
    $('.question-title').toggle();
    $('.question-body').toggle();
    $('.question-form').toggle();
    $('.edit-question-link').toggle();
}

$(document).ready(function() {
    $('.question-form').hide();

    $('.edit-question-link').click(function(){
        question_toggle();
        $('.answer-form').hide();
        $('.answer-body').show();
        $('.edit-answer-link').show();
        $('.new-answer-form').hide();
        $('#errors').html('');
    });

    $('.question-cancel').click(function(){
        $('#errors').html('');
        $('.new-answer-form').show();
        question_toggle();
        $('.question-form form')[0].reset();
    });

    $('form.edit_question').bind('ajax:success',
      function(e, data, status, xhr) {
          $('#errors').html('');
          if (data.status_ok) {
              $('.question-title').html(data.question.title);
              $('.question-body').html(data.question.body);
              question_toggle();
              $('.new-answer-form').show();
          } else {
              $.each(data.errors, function(index, message) {
                  $('#errors').append(message + "<br>");
              })
          }
      });
});