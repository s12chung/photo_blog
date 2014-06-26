$(function() {
    var $popup = $(data_behavior('popup'));
    $popup.children().hide();

    var show_popup = function(title, content) {
        $popup.find(data_behavior('popup_title')).html(title);
        $popup.find(data_behavior('popup_content')).html(content);
        $popup.fade_show();

        $(data_behavior('close_x')).click(function(e) {
            e.preventDefault();
            $popup.fade_hide();
        });
    };

    var $body = $('body');
    $body.on('click', data_behavior('show_popup'), function(e) {
        e.preventDefault();
        show_popup(swipe.li().data('title'), popup_contents[swipe.getPos()]);
    });
    $body.on('click', data_behavior('show_comment'), function(e) {
        e.preventDefault();
        show_popup(swipe.li().data('title'), comments_content);
    });
});