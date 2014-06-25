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
            startSlide: parseInt($swipe.data('index')),
            callback: function (index, li) {
                var $li = $(li);

                if (location.pathname != $li.data('path')) {
                    programmatic_state_change = true;
                    History.pushState(({ change: index - swipe_states.shift() }), $li.data('title'), $li.data('path'));
                    programmatic_state_change = false;
                }
                swipe_states.push(index);
                if (!defined($li.data('loaded'))) {
                    $.ajax($li.data('path'), { dataType: 'script' });
                }
                else {
                    $li.find(data_behavior('summary_content_container')).css({ opacity: 0, display: 'hidden' });
                    setTimeout(function () {
                        $li.find(data_behavior('summary_content_container')).fade_show();
                    }, 100);
                }
                clearTimeout(singleTapTimer);
            }
        });

        Behavior.resize_swipe();
        $(window).resize(Behavior.resize_swipe);

        History.Adapter.bind(window, 'statechange', function() {
            if (!programmatic_state_change) {
                programmatic_state_change = false;
                var change = History.getState().data.change;
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