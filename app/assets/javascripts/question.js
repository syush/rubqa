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

    $('form.edit_question').bind('ajax:success', function(e, data, status, xhr) {
        $('.question-title').html(data.question.title);
        $('.question-body').html(data.question.body);
        question_toggle();
        $('.new-answer-form').show();
    }).bind('ajax:error', function(e, xhr, status, error) {
        errors = $.parseJSON(xhr.responseText);
        $.each(errors, function(index, message) {
            $('#errors').append(message + "<br>");
        });
    }).bind('ajax:before', function() {
        $('#errors').html('');
    });
});