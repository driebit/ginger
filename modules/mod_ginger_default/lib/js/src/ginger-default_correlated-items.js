(function ($) {
    'use strict';

    $.widget('ui.ginger_default_correlated_items', {
        _create: function () {
            var me               = this,
                element          = me.element,
                viewBtns         = element.find('[data-show-section]'),
                masonryContainer = $('.ginger-correlated-items__tiles');

            viewBtns.on('click', function () {
                var section = $(this).attr('data-show-section');

                me._showSection(section);
            });

            masonryContainer.imagesLoaded(function() {
                masonryContainer.masonry({
                	itemSelector: 'li'
            	});
    		});
        },

        _showSection: function (section) {
            var element     = this.element,
                allSections = element.find('[data-section]'),
                allButtons  = element.find('[data-show-section]');

            function showIfSectionMatches (element, attrName) {
                if (element.attr(attrName) === section) {
                    element.addClass('is-shown');
                } else {
                    element.removeClass('is-shown');
                }
            }

            $.each(allButtons, function () {
                showIfSectionMatches($(this), 'data-show-section');
            });

            $.each(allSections, function () {
                showIfSectionMatches($(this), 'data-section');
            });
        }
    });
})(jQuery);
