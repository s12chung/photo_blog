load_behavior(function() {
    $(data_behavior("scroll_to")).click(function(e) {
        e.preventDefault();
        e.stopPropagation();
        $.scrollTo($(this).data('scroll-to'), 400);
    });
});
