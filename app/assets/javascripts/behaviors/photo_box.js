load_behavior(function() {
    var resize_photo_box = function() {
        var window_height = $(window).height();
        $(data_behavior('photo_box')).height(window_height);

        var $summary = $(data_behavior('summary'));
        $summary.css({ top: (window_height * 0.70) - ($summary.height()/2) });
    };
    resize_photo_box();
    $(window).resize(resize_photo_box);
});