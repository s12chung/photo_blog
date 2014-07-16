Jcontroller.create('application', {
    html: {
        after: function() {
            if (is_mobile) {
                window.addEventListener('load', function() {
                    FastClick.attach(document.body);
                }, false);
            }
        }
    }
});