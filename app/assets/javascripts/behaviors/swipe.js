$(function() {
    var $swipe = $(data_behavior('swipe'));
    if ($swipe.length > 0) Swipe($swipe[0]);
});