$.widget("ui.loadmore", {

    _create: function() {
        var me = this,
            btn = $(me.element).next(),
            listItems = $(me.element).children(),
            maxLoadItemsLength = $(me.element).data('loadmore-items-length') || 10,
            maxLoadListLength = $(me.element).data('loadmore-list-length') || 5,
            loadmoreID = $(me.element).data('loadmore-id'),
            counter = 1;

        $.each(listItems, function(i , val){
            if (i >= maxLoadListLength) {
                $(val).hide();
            }
        });

        btn.on('click', function () {
            counter = counter + maxLoadItemsLength;

            $.each(listItems, function(i , val){
                if(i < counter) {
                    $(val).show();
                }
            });

            if(counter + counter > listItems.length) {
                $(this).hide();
            }
        });

        inputs = $(me.element).find('input:checked');

        if(inputs.length) {
            $('#'+loadmoreID).find('.selected-inputs').prepend(inputs.parent());
            inputs.parent()
                .show()
                    .addClass('loadmore-selected');
        }
    }

});
