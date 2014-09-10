$(function() {
    var $read_mode = $(data_behavior('read_mode'));

    if ($read_mode.length > 0) {
        var read_text = "Reading";
        var edit_text = "Editing";
        var COOKIE_KEY = 'read';

        function set_links(read) {
            $(data_behavior('read_mode_container')).find('a').each(function(index, element) {
                var $element = $(element);
                $element.prop('href', $element.data((read ? 'read' : 'edit') + '-url'));
            });
        }
        function set_read_state(read) {
            $read_mode.html(read ? read_text : edit_text);
            set_links(read);
        }

        var is_reading = $.cookie(COOKIE_KEY);
        set_read_state(defined(is_reading) ? (is_reading === 'true') : false);
        $read_mode.click(function(e) {
            e.preventDefault();
            var $this = $(this);
            var read = $this.html() === read_text;
            read = !read;
            $.cookie(COOKIE_KEY, read);
            set_read_state(read);
        });
    }
});