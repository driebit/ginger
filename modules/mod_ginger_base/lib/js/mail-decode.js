(function ($) {
   'use strict';

    $.widget( "ui.mail_decode", {
        _init: function() {
            this.init();
        },
        
        _decode: function(a) {            
            // ROT13 : a Caesar cipher 
            // letter -> letter' such that code(letter') = (code(letter) + 13) modulo 26
            return a.replace(/[a-zA-Z]/g, function(c){
              return String.fromCharCode((c <= "Z" ? 90 : 122) >= (c = c.charCodeAt(0) + 13) ? c : c - 26);
            });
        },
        
        _open: function(elm) {
            var me = this,
                encAddr = elm.attr("address"),
                decAddr = me._decode(encAddr),
                mailto = "mailto:" + decAddr;
                    
            elm[0].setAttribute("href", mailto);
        },

        init: function() {

            var me = this,
                element = me.element;
            
            console.log("zus");
                    
            element.on('click', function() {
                me._open(element);
            });

        }
    });

})(jQuery);
