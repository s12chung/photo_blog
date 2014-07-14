Jcontroller.create('application', {
    html: {
        markdown: function() {
            Jcontroller.find('posts').html.index();
        },
        after: function() {
            if (is_mobile) {
                window.addEventListener('load', function() {
                    FastClick.attach(document.body);
                }, false);
            }
        }
    }
});