Behavior.resize_swipe = function() {
    var $swipe = $(data_behavior('swipe'));
    var window_height = $(window).height();
    $swipe.find('li').height(window_height);
    $swipe.find(data_behavior('pinch_zoom')).height(window_height);
};

$(function() {
    var $swipe = $(data_behavior('swipe'));
    if ($swipe.length > 0) swipe = new Swipe($swipe[0], {
        startSlide: parseInt($swipe.data('index')),
        callback: function(index, li) {
            var $li = $(li);
            if (!defined($li.data('loaded'))) {
                $.get($li.data('path') + ".js");
            }
            else {
                $li.find(data_behavior('summary_content_container')).css({ opacity: 0, display: 'hidden' });
                setTimeout(function() {
                    $li.find(data_behavior('summary_content_container')).fade_show();
                }, 100);
            }
            clearTimeout(singleTapTimer);
        }
    });
    Behavior.resize_swipe();
    $(window).resize(Behavior.resize_swipe);
});