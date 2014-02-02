$(function() {
    $('body').on('click', data_behavior('scroll_to'), function(e) {
        e.preventDefault();
        e.stopPropagation();
        var options = { offset: { top: -5 }};
        if (is_mobile) options.offset.top += -40;
        $.scrollTo($(this).data('scroll-to'), 400, options);
    });
});