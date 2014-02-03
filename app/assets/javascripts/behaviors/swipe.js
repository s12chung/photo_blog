Behavior.resize_swipe = function() {
    var $swipe = $(data_behavior('swipe'));
    var window_height = $(window).height();
    $swipe.find('li').height(window_height);
    $swipe.find(data_behavior('pinch_zoom')).height(window_height);
};

$(function() {
    var $swipe = $(data_behavior('swipe'));
    if ($swipe.length > 0) new Swipe($swipe[0], {
        startSlide: parseInt($swipe.data('index')),
        callback: function(index, element) {
            $.get($(element).data('path') + ".js")
        }
    });
    Behavior.resize_swipe();
    $(window).resize(Behavior.resize_swipe);
});