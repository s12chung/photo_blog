load_behavior(function() {
    $(data_behavior('toggle_summary')).click(function(e) {
        e.preventDefault();
        var $summary = $(this);
        $summary.css({ opacity: $summary.css('opacity') === "0" ? 1 : 0 });
    });
});