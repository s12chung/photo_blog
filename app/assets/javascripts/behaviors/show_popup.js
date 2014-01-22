$(function() {
    $('body').on('click', data_behavior('show_popup'), function(e) {
        photoswipe.removeEventHandlers();

        e.preventDefault();
        var $popup = $(data_behavior('popup'));
        $popup.css({ opacity: 1, visibility: 'visible' });

        $(data_behavior('close_x')).click(function(e) {
            photoswipe.addEventHandlers();

            e.preventDefault();
            $popup.css({ opacity: 0 });

            setTimeout(function() {
                var $close_x = $popup.children().first();
                $popup.css({ visibility: 'hidden' }).empty().append($close_x);
            }, 400);
        });

        $.get($(this).prop('href'));
    });
});