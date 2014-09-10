$(function() {
    var $photo_box = $(data_behavior('photo_box'));
    if ($photo_box.length > 0) {
        var resize_photo_box = function() {
            var window_height = $(window).height();
            $photo_box.height(window_height);
        };
        resize_photo_box();
        $(window).resize(resize_photo_box);

        $(document).keydown(function(e) {
            if ($photo_box.in_view()) {
                var suffix = undefined;
                switch(e.which) {
                    case 37: // left
                        suffix = "left";
                        break;
                    case 39: // right
                        suffix = "right";
                        break;
                    default: return;
                }
                if (defined(suffix)) {
                    var $link = $(data_behavior('photo_box_' + suffix));
                    if ($link.length > 0) {
                        $link[0].click();
                    }
                }
            }
        });
    }
});