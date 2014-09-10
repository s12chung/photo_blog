(function($){
    $.fn.fade_show = function() {
        var $this = $(this);
        $this.show();
        $this.children().show();
        setTimeout(function() {
            $this.css({ opacity: 1, visibility: 'visible' });
        }, 0);
    };

    $.fn.fade_hide = function() {
        var $this = $(this);
        $this.css({ opacity: 0 });
        setTimeout(function() {
            $this.css({ visibility: 'hidden' });
            $this.hide();
            $this.children().hide();
        }, 400);
    };
    $.fn.in_view = function() {
        var $window = $(window);
        var window_top = $window.scrollTop();
        var window_bottom = window_top + $window.height();

        var $this = $(this);
        var element_top = $this.offset().top;
        var element_bottom = element_top + $this.height();

        return ((element_bottom <= window_bottom) && (element_bottom >= window_top)) ||
            ((element_top <= window_bottom) && (element_top >= window_top));
    };
})(jQuery);