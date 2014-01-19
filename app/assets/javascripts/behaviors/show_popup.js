$(function() {
    $('body').on('click', data_behavior('show_popup'), function(e) {
        photoswipe.removeEventHandlers();

        e.preventDefault();
        var $popup = $(data_behavior('popup'));
        $popup.addClass('visible');

        $(data_behavior('close_x')).click(function(e) {
            photoswipe.addEventHandlers();

            e.preventDefault();
            $popup.removeClass('visible');

            var $close_x = $popup.children().first();
            $popup.empty().append($close_x);
        });

        $.get($(this).prop('href'));
    });
});