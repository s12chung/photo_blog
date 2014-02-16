$(function() {
    var $popup = $(data_behavior('popup'));
    $popup.children().hide();

    $('body').on('click', data_behavior('show_popup'), function(e) {
        e.preventDefault();
        $popup.fade_show();

        $(data_behavior('close_x')).click(function(e) {
            e.preventDefault();
            $popup.fade_hide();
        });
    });
});