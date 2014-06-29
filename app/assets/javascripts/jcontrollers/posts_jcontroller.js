Jcontroller.create('posts', {
    html: {
        index: function() {
            flow_type({ minFont: 12, maxFont: 30});
        },
        show: function(params) {
            flow_type({ minFont: 20, maxFont: 30});
            if (is_mobile) {
                popup_contents = new Array(params.posts_size);
                popup_contents[params.post_index] = params.popup_content;
                comments_content = params.comments_content
            }
        },
        edit: function(params) {
            $(document).imagesLoaded(function() {
                var $crop_image = $(data_behavior("crop"));
                var $crop_preview = $(data_behavior("crop_preview"));
                var ratio = params.ratio;
                var cached_coords = params.cached_coords;

                var update = function(coords) {
                    cached_coords = coords;
                    $.each(["x", "y", "w", "h"], function(index, field) {
                        $('#post_crop_' + field).val(coords[field]);
                    });

                    $crop_preview.each(function(index, element) {
                        var $element = $(element);
                        var $parent = $element.parent();
                        var parent_width = $parent.width();
                        var parent_height = $parent.height();
                        $element.css({
                            width: Math.round(parent_width/coords.w * $crop_image.width()) + 'px',
                            height: Math.round(parent_height/coords.h * $crop_image.height()) + 'px',
                            marginLeft: '-' + Math.round(parent_width/coords.w * coords.x) + 'px',
                            marginTop: '-' + Math.round(parent_height/coords.h * coords.y) + 'px'
                        });
                    });
                };
                var resize_preview = function() {
                    var $parent = $crop_preview.parent();
                    $parent.height($parent.width()/ratio);
                    update(cached_coords);
                };
                resize_preview();
                $(window).resize(resize_preview);

                var jcrop;
                var crop_image_width = $crop_image.width();
                $crop_image.Jcrop({
                    aspectRatio: ratio,
                    setSelect: [cached_coords.x, cached_coords.y,
                            cached_coords.x + cached_coords.w,
                            cached_coords.y + cached_coords.h],
                    onSelect: update,
                    onChange: update
                }, function(){
                    jcrop = this;
                });

                $('body').on('submit', data_behavior('crop_form'), function() {
                    jcrop.disable();
                });
            });
        }
    },
    js: {
        show: function(params) {
            var $li = swipe.li(params.post_index);
            $li.html(params.photoswipe_content);
            $li.data('loaded', true);

            popup_contents[params.post_index] = params.popup_content;
            picturefill({
                elements: $li.find(data_behavior('picturefill'))
            });

            Behavior.pinch_zoom($li.find(data_behavior('pinch_zoom')));
            Behavior.resize_swipe();
        }
    }
});