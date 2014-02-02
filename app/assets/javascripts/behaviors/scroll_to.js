$(function() {
    $('body').on('click', data_behavior('scroll_to'), function(e) {
        e.preventDefault();
        e.stopPropagation();
        var $this = $(this);
        var offset = $this.data('offset');
        var options = { offset: { top: defined(offset) ? offset : 0 } };
        if (is_mobile) options.offset.top += -40;
        $.scrollTo($this.data('scroll-to'), 400, options);
    });
});