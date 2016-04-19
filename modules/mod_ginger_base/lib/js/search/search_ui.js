$.widget("ui.search_ui", {

    _create: function() {

        var me = this;

        $(document).on('widgetmanager:loaded', $.proxy(me.init, this));

        me.source = null;

    },

    init: function() {

        //after all widget's _create function
        var me = this,
            inputSearch = $(document).find('.input-search'),
            queryString = $.url().param('searchterm'),
            documentWidth = $(document).width();

        window.onhashchange = $.proxy(me.hashChanged, me);

        inputSearch.focus();

        $('.global-search__submit').on('click', function(event) {
            event.preventDefault();
            $(document).trigger('search:doSearch');
        });

        $(document).on('search:inputChanged search:doSearch', function(event, source) {

            if (source) {
                me.source = source;
            } else {
                me.source = null;
            }

            me.setHash();

        });

        $('.search__filters__mobile').on('click', function(event) {
            event.preventDefault();
            me.toggleSearchOptions();
        });

        $('.search__filters__title').on('click', function(event) {
            event.preventDefault();
            me.toggleSearchSection($(this));
        });

        var hash = window.location.hash;

        if (!hash || hash == '') {
          me.setHash();
        } else {
          me.hashChanged();
        }

    },


    getWidgets: function() {

        var me = this,
            widgetEls = $("[class*='do_search_cmp']"),
            widgetRefs = []

        $.each(widgetEls, function(i, element) {

            var classnames = element.className.split(/\s+/),
                element = $(element);

            $.each(classnames, function(j, classname) {
                if (classname.match(/do_search_cmp/)) {

                    var widgetName = classname.replace(/^do_/, '');
                    widgetRefs.push(element.data('ui-' + widgetName));
                }
            });
        });

        return widgetRefs;

    },

    getMergedValues: function(reset) {

        var me = this,
            checkboxValue,
            inputfieldValue,
            type,
            mergedValues = {},
            widgetRefs = me.getWidgets();

        $.each(widgetRefs, function(i, widget) {

            if (!widget.getValues || typeof widget.getValues != 'function') return;

            var widgetVals = widget.getValues();

            if (widgetVals && Array.isArray(widgetVals) && widgetVals.length > 0) {

                $.each(widgetVals, function(j, val) {

                    if (!mergedValues[val.type]) {
                        if (Array.isArray(val.values)) {
                            mergedValues[val.type] = [];
                        }
                    }

                    if (Array.isArray(val.values)) {
                        mergedValues[val.type] = mergedValues[val.type].concat(val.values);
                    } else {
                        mergedValues[val.type] = val.values;
                    }

                });
            }
        });

        return mergedValues;

    },

    setHash: function(force) {

        var me = this,
            mergedValues = me.getMergedValues();

        var json = JSON.stringify(mergedValues);
        var hash = btoa(json);

        window.location.hash = hash;

        if (force) {
            me.hashChanged();
        }
    },

    hashChanged: function() {

        var me = this,
            hash = window.location.hash.substring(1, window.location.hash.length),
            json = atob(hash),
            values = jQuery.parseJSON(json);

        $.proxy(me.setWidgetsState(values), me);
        $.proxy(me.doSearch(values), me);

        $('.search__filters').css('opacity', '1');

    },

    setWidgetsState: function(values) {

        var me = this,
            widgets = me.getWidgets();

        $.each(widgets, function(i, widget) {

            if (widget.setValues && typeof widget.setValues == 'function') {
              widget.setValues(values);
            }
        });
    },

    doSearch: function(values) {

        var me = this;

        $(document).trigger("search:doSearchWire", {
            'values': values
        });

    },

    toggleSearchOptions: function() {
        $('.search__filters').toggleClass('is-open');
    },

    toggleSearchSection: function(title) {
        title.parent().siblings().removeClass('is-open');
        title.parent().toggleClass('is-open');
    }

});
