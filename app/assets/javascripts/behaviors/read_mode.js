load_behavior(function() {
    var read_text = "Read";
    var edit_text = "Edit";
    var $read_mode = $(data_behavior('read_mode'));

    function set_links(is_reading) {
        $(data_behavior('read_mode_container')).find('a').each(function(index, element) {
            var $element = $(element);
            $element.prop('href', $element.data((is_reading ? 'read' : 'edit') + '-url'));
        });
    }

    if ($read_mode.length > 0) {
        set_links(false);
        $read_mode.html(read_text);
        $read_mode.click(function(e) {
            e.preventDefault();
            var $this = $(this);
            var is_reading = $this.html() === read_text;
            $this.html(is_reading ? edit_text : edit_text);
            set_links(is_reading);
        });
    }
});