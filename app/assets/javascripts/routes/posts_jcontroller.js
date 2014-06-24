Jcontroller.create('posts', {
    html: {
        show: function(params) {
            if (is_mobile) {
                popup_contents = new Array(params.posts_size);
                popup_contents[params.post_index] = params.popup_content;
            }
        }
    },
    js: {
        show: function(params) {
            var $li = $(data_behavior('swipe')).find('li').eq(params.post_index);
            $li.html(params.photoswipe_content);
            $li.data('loaded', true);

            popup_contents[params.post_index] = params.popup_content;

            Behavior.pinch_zoom($li.find(data_behavior('pinch_zoom')));
            Behavior.resize_swipe();
        }
    }
});