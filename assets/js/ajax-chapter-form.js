$(document).ready(function() {
    $('#ajax-chapter-form').on('submit', function(event) {
        event.preventDefault(); 

        var formData = new FormData(this);

        var createChapterUrl = "/chapter/create";

        $.ajax({
            url: createChapterUrl,
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                if (response.status === 'success') {
                    $('#chapter-list').append('<p>' + response.chapter.name + '</p><p> - - No episodes yet</p><p><a href="/episodes/create/' + response.chapter.id + '/' + response.courseId + '">Add episode</a></p>');

                    $('#ajax-chapter-form')[0].reset();
                }
            },
            error: function(xhr) {
                $('#chapter-form-messages').html('<p>An error occurred.</p>');
            }
        });
    });
});
