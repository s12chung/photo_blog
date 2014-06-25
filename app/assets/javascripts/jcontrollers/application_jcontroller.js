Jcontroller.create('application', {
    html: {
        markdown: function() {
            Jcontroller.find('posts').html.index();
        }
    }
});