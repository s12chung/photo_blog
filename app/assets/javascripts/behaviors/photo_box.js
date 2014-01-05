load_behavior(function() {
    var resize_photo_box = function() {
        var window_height = $(window).height();
        $(data_behavior('photo_box')).height(window_height);
    };
    resize_photo_box();
    $(window).resize(resize_photo_box);
});