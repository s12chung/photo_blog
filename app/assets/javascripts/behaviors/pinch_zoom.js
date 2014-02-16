Behavior.pinch_zoom = function($element) {
    new RTP.PinchZoom($element, {});
};

$(function() {
    $(data_behavior('pinch_zoom')).each(function() {
        Behavior.pinch_zoom($(this));
    });
});