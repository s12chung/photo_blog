$(function() {
    $('body').on('click', data_behavior('show_popup'), function(e) {
        e.preventDefault();
        var $popup = $(data_behavior('popup'));
        $popup.css({ opacity: 1, visibility: 'visible' });

        $(data_behavior('close_x')).click(function(e) {
            $('body').scrollTop(0);

            e.preventDefault();
            $popup.css({ opacity: 0 });

            setTimeout(function() {
                var $close_x = $popup.children().first();
                $popup.css({ visibility: 'hidden' });
            }, 400);
        });

        $(data_behavior('popup_content')).empty();
        Behavior.toggle_popup_spinner();
        $('body').scrollTop(0);

        $.get($(this).prop('href'));
    });
});
Behavior.toggle_popup_spinner = function() {
  $(data_behavior('popup_spinner')).toggle();
};