(function() {
    var visibile;

    load_behavior(function() {
        var $summary = $(data_behavior('summary_content'));

        if (!defined(visibile)) { visibile = true; }
        var toggle = function() {
            visibile ? $summary.show() : $summary.hide();
        };

        toggle();
        $(data_behavior('toggle_summary')).click(function(e) {
            e.preventDefault();
            visibile = !visibile;
            $summary.fadeTo(400, visibile ? 1 : 0, toggle);
        });
    });
})();