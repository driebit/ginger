$.widget('ui.search_cmp_filters_load', {
    _create: function() {
        var me = this,
            btn = $('.filter-down-btn'),
            listItem = $(me.element).find('li.rest-subject'),
            counter = 1;

        btn.on('click', function () {
            counter = counter + 10;
            $.each(listItem, function(i , val){
                if(i < counter) {
                    $(val).removeClass('hidden');
                }
            });

            if(counter + counter > listItem.length) {
                $(this).hide();
            }
        });
    },
});
