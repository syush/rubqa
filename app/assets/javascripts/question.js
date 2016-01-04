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

    question_id = window.location.pathname.match( /\/questions\/(\d*)/ )[1];
    PrivatePub.subscribe('/questions/' + question_id + '/answers', function(data, channel) {
        if (data.action == 'update') {
            $("#answer-" + data.answer.id + " .answer-body").html(data.answer.body);
        }
    });

    PrivatePub.subscribe("/questions", function(data, channel) {
        switch(data.action) {
            case 'create':
                $("body").append(
                    '<div class="question" id="question-' + String(data.question.id) + '">' +
                      '<a href="/questions/' + String(data.question.id) + '">' +
                        '<h3>' + data.question.title + '</h3>' +
                      '</a>' +
                      '<p>' + data.question.body.substring(0, 100) + '</p>' +
                      '<hr>' +
                    '</div>'
                );
                break;
            case 'update':
                $("#question-" + data.question.id + " a h3").html(data.question.title);
                $("#question-" + data.question.id + " p").html(data.question.body);
                break;
            case 'destroy':
                $("#question-" + data.question_id).remove();
        }
    });


});
