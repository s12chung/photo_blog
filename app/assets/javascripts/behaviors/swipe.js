Behavior.resize_swipe = function() {
    var $swipe = $(data_behavior('swipe'));
    var window_height = $(window).height();
    $swipe.find('li').height(window_height);
    $swipe.find(data_behavior('pinch_zoom')).height(window_height);
};
$(function() {
    var $swipe = $(data_behavior('swipe'));
    if ($swipe.length > 0) {
        var swipe_states = [parseInt($swipe.data('index'))];
        var programmatic_state_change = false;

        swipe = new Swipe($swipe[0], {
            startSlide: swipe_states[0],
            callback: function (index, li) {
                var $li = $(li);

                if (location.pathname != $li.data('path')) {
                    programmatic_state_change = true;
                    History.pushState(null, $li.data('title'), $li.data('path'));
                    programmatic_state_change = false;
                    swipe_states.push(index);
                }
                if ($li.data('loaded') === true) {
                    $li.find(data_behavior('summary_content_container')).css({ opacity: 0, display: 'hidden' });
                    setTimeout(function () {
                        $li.find(data_behavior('summary_content_container')).fade_show();
                    }, 100);
                }
                else {
                    $.ajax($li.data('path'), { dataType: 'script' });
                }
                clearTimeout(singleTapTimer);
            }
        });
        swipe.li = function(index) {
            if (blank(index)) {
                index = swipe.getPos();
            }
            return $(data_behavior('swipe')).find('li').eq(index);
        };

        Behavior.resize_swipe();
        $(window).resize(Behavior.resize_swipe);

        History.Adapter.bind(window, 'statechange', function() {
            if (!programmatic_state_change) {
                swipe_states.pop();
                var change = swipe_states[swipe_states.length - 1] - swipe.getPos();
                if (change === -1) {
                    swipe.prev();
                }
                else if (change === 1) {
                    swipe.next();
                }
            }
        });
    }
});