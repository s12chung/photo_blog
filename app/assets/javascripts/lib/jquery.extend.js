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
})(jQuery);