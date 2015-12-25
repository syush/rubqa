function answer_toggle_back(id) {
    $('#' + id + ' .answer-body').show();
    $('#' + id + ' .answer-form').hide();
    $('#' + id + ' .edit-answer-link').show();
    $('.new-answer-form').show();
};

$(document).ready(function() {
    $('.answer-form').hide();

    $('.edit-answer-link').click(function(){
        var id = $($($(this).parents()[0]).parents()[0]).attr('id');
        $('.answer-body').show();
        $('.answer-form').hide();
        $('.edit-answer-link').show();
        $('#' + id + ' .answer-body').hide();
        $('#' + id + ' .answer-form').show();
        $('#' + id + ' .edit-answer-link').hide();
        $('.question-title').show();
        $('.question-body').show();
        $('.edit-question-link').show();
        $('.question-form').hide();
        $('.new-answer-form').hide();
        $('#errors').html('');
    });

    $('.answer-cancel').click(function(){
        var id = $($($(this).parents()[0]).parents()[0]).attr('id');
        $('#errors').html('');
        answer_toggle_back(id);
        $('#' + id + ' .answer-form form')[0].reset();
    });

    $('form.edit_answer').bind('ajax:success', function(e, data, status, xhr) {
        var id = $($($(this).parents()[0]).parents()[0]).attr('id');
        $('#' + id + ' .answer-body').html(data.body);
        answer_toggle_back(id);
    }).bind('ajax:error', function(e, xhr, status, error) {
        errors = $.parseJSON(xhr.responseText);
        $.each(errors, function(index, message) {
            $('#errors').append(message + "<br>");
        })
    }).bind('ajax:before', function() {
        $('#errors').html('');
    });
});