$(function() {
    $('body').on('click', data_behavior('scroll_to'), function(e) {
        e.preventDefault();
        e.stopPropagation();

        var $this = $(this);
        var $scroller = $this.closest(data_behavior("scroller"));
        $scroller = $scroller.length > 0 ? $scroller : $;
        $scroller.scrollTo($this.data('scroll-to'), 400);
    });
});