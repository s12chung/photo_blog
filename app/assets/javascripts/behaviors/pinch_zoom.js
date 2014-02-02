$(function() {
    var $pinch_zoom = $(data_behavior('pinch_zoom'));
    $($pinch_zoom).each(function() {
        new RTP.PinchZoom($(this), {});
    });

    var resize_pinch_zoom = function() {
        var window_height = $(window).height();
        $pinch_zoom.height(window_height);
    };
    resize_pinch_zoom();
    $(window).resize(resize_pinch_zoom);
});