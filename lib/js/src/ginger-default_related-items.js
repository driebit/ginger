(function ($) {
    'use strict';

    $.widget('ui.ginger_default_related_items', {
        _create: function () {
            var me               = this,
                element          = me.element,
                viewBtns         = element.find('[data-show-section]'),
                masonryContainer = $('.ginger-correlated-items__tiles');

            viewBtns.on('click', function () {
                var button  = $(this),
                    section = button.attr('data-show-section');

                me._showSection(section);
            });

            masonryContainer.imagesLoaded(function() {
                masonryContainer.masonry({
                	itemSelector: 'li'
            	});
    		});
        },

        _showSection: function (section) {
            var allSections = this.element.find('[data-show-section]');

            $.each(allSections, function (currentSection) {
                if (currentSection.attr('data-show-section') === section) {
                    currentSection.addClass('is-shown');
                } else {
                    currentSection.removeClass('is-shown');
                }
            });
        }
    });
})(jQuery);
