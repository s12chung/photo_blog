Behavior.resize_swipe = function() {
    var $swipe = $(data_behavior('swipe'));
    var window_height = $(window).height();
    $swipe.find('li').height(window_height);
    $swipe.find(data_behavior('pinch_zoom')).height(window_height);
};
$(function() {
    var $swipe = $(data_behavior('swipe'));
    if ($swipe.length > 0) {
        var jiggling = false;
        var initial_state = parseInt($swipe.data('index'));
        var programmatic_state_change = false;

        swipe = new Swipe($swipe[0], {
            startSlide: initial_state,
            callback: function (index, li) {
                var $li = $(li);

                if (location.pathname != $li.data('path') && !jiggling) {
                    programmatic_state_change = true;
                    var path = $li.data('path');
                    History.pushState({ index: index }, $li.data('title'), path);
                    page_view(path);
                    programmatic_state_change = false;
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
            return swipe.slides().eq(index);
        };
        swipe.slides = function() {
            return $(data_behavior('swipe')).find('li');
        };

        Behavior.resize_swipe();
        $(window).resize(Behavior.resize_swipe);

        History.Adapter.bind(window, 'statechange', function() {
            if (!programmatic_state_change) {
                var index = History.getState().data.index;
                if (blank(index)) index = initial_state;

                var change = index - swipe.getPos();
                if (change === -1) {
                    swipe.prev();
                }
                else if (change === 1) {
                    swipe.next();
                }

                $('title').html(swipe.li().data('title'));
                page_view(swipe.li().data('path'));
                $(data_behavior('popup')).fade_hide();
            }
        });

        var COOKIE_KEY = "JIGGLE_INTRO_DONE";
        if ($.cookie(COOKIE_KEY) != "true") {
            var JIGGLE_DELAY = 1000;
            var JIGGLE_SPEED = 1000;
            var JIGGLE_LENGTH = 200;

            var position_change = initial_state == swipe.slides().length - 1 ? -1 : 1;
            var start_jiggle = function () {
                jiggling = true;
                swipe.slide(swipe.getPos() + position_change, JIGGLE_SPEED);
                setTimeout(end_jiggle, JIGGLE_LENGTH)
            };
            var end_jiggle = function () {
                swipe.slide(swipe.getPos() - position_change, JIGGLE_SPEED);
                $.cookie(COOKIE_KEY, true, { expires: 365 });
                setTimeout(function () {
                    jiggling = false;
                }, JIGGLE_SPEED + 100)
            };
            window.addEventListener('load', function () {
                setTimeout(start_jiggle, JIGGLE_DELAY);
            }, false);
        }
    }
});