$(function() {
    var $popup = $(data_behavior('popup'));
    var $content_child = $(data_behavior('popup_content')).children().first();

    $('body').on('click', data_behavior('show_popup'), function(e) {
        e.preventDefault();
        $content_child.show();
        $popup.css({ opacity: 1, visibility: 'visible' });

        $(data_behavior('close_x')).click(function(e) {
            e.preventDefault();
            $popup.css({ opacity: 0 });

            setTimeout(function() {
                var $close_x = $popup.children().first();
                $popup.css({ visibility: 'hidden' });
                $content_child.hide();
            }, 400);
        });
    });
});