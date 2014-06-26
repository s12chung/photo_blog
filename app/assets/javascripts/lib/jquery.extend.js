(function($){
    $.fn.fade_show = function() {
        var $this = $(this);
        $this.show();
        $this.children().show();
        setTimeout(function() {
            $this.removeClass('hiding hidden');
        }, 0);
    };

    $.fn.fade_hide = function() {
        var $this = $(this);
        $this.addClass('hiding');
        setTimeout(function() {
            $this.addClass('hidden');
            $this.hide();
            $this.children().hide();
        }, 400);
    };
})(jQuery);