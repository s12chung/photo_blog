$(function(){
    $(data_behavior('select_all')).each(function() {
        var $this = $(this);
        $this.click(function() {
            $this.select();

            // Work around Chrome's little problem
            $this.mouseup(function() {
                // Prevent further mouseup intervention
                $this.unbind("mouseup");
                return false;
            });
        });
    });
});