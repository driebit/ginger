
$.widget("ui.expanditems", {

    _create: function() {

        var me = this,
            widgetElement = $(me.element),
            inputs = widgetElement.find('li:not(:has(>button))'),
            showMax = widgetElement.data('showitems') || 5,
            title = widgetElement.find('.search__filters__title:eq(0)'),
            width = $(window).width(),
            itemsExpanded = false,
            button = widgetElement.find('.search__filters__expanditems');

        me.widgetElement = widgetElement;
        me.inputs = inputs;
        me.itemsExpanded = itemsExpanded;
        me.showMax = showMax;
        me.title = title;
        me.button = button;

        button.hide();

        if (inputs.length > showMax) {

            button.show();

            button.on('click', function () {
                me.itemsExpanded = !me.itemsExpanded;
                me.render();
            });
        }

        me.render();

    },

    render: function() {

      var me = this;

      me.inputs.hide();

      me.inputs.each(function (i,val) {

          $val = $(val);

          if (me.itemsExpanded || (i < me.showMax)) {
            $val.show();
          }

      });

      me.button.text(me.itemsExpanded ? me.button.data('transless') : me.button.data('transmore'));

    }

});
