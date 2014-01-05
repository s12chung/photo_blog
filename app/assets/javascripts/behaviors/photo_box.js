load_behavior(function() {
    var resize_photo_box = function() {
        $(data_behavior('photo_box')).height($(window).height() - 20);
    };
    resize_photo_box();
    $(window).resize(resize_photo_box);
});
