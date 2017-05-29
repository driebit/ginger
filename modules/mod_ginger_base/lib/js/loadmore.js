$.widget("ui.loadmore", {

    _create: function() {
        var me = this,
            btn = $(me.element).next(),
            listItems = $(me.element).children(),
            maxLoadItemsLength = $(me.element).data('loadmore-items-length') || 10,
            maxLoadListLength = $(me.element).data('loadmore-list-length') || 5,
            loadmoreID = $(me.element).data('loadmore-id'),
            loadmoreOption = $(me.element).data('loadmore-option')
            counter = maxLoadListLength;

        $.each(listItems, function(i , val){
            if (i >= maxLoadListLength) {
                $(val).addClass('hidden');
            }
        });



        btn.on('click', function () {
            if(listItems.not('.hidden').length === maxLoadListLength) {
                counter = maxLoadListLength;
            }

            console.log(counter);

            counter = counter + maxLoadItemsLength;

            $.each(listItems, function(i , val){
                if(i < counter) {
                    $(val).removeClass('hidden');
                }
            });

            if(counter > listItems.length) {
                $(this).hide();
            }
        });

        if(loadmoreOption) {
            var inputs = $(me.element).find('input:checked'),
                listSelector = $('#'+loadmoreID);

            if(inputs.length) {
                listSelector
                    .find('.selected-inputs')
                        .prepend(inputs.parent());

                loadmoreOption === 'loose' ?
                    inputs.parent().removeClass('hidden').addClass('loadmore-selected'):
                    inputs.parent().removeClass('hidden');
            }
        }
    }

});
