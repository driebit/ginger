
$.widget( "ui.carousel", {

    _create: function() {

         var me = this,
             widgetElement = $(me.element);

        console.log('create carousel');
        console.log(this.options);

        if (this.options){
            $(me).slick(this.options);
        } else {
            $(me).slick();
        }

    }
});

