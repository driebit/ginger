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
            documentWidth = $(document).width(),
            element = me.element;

        window.onhashchange = $.proxy(me.hashChanged, me);

        me.searchOnLoad = (element.data('search-on-load') != undefined) ? element.data('search-on-load') : true;

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

        $(document).on('search:doSearch', function(event, source) {
            me.toggleSearchOptions(true);
        });

        $('.search__filters__title').on('click', function(event) {
            event.preventDefault();
            me.toggleSearchSection($(this));
        });

        var hash = window.location.hash;

        if (!hash || hash == '') {

            if (!window.location.search) {
                me.blankSearchStarted = true;
            }

            me.setHash();
        } else {
            me.hashChanged();
        }

        // This should be ~pagesession, but see https://github.com/zotonic/zotonic/issues/1622
        pubzub.subscribe("~session/search/facets", function (topic, msg) {
            if (msg.payload) {
                me.setFacets(msg.payload);
            }
        });

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

        mergedValues.facets = this.getMergedFacets();

        return mergedValues;
    },

    /**
     * Get facets (a.k.a. aggregations) to segment the search results by.
     */
    getMergedFacets: function() {
        return this.getWidgets()
            .filter(function(widget) {
                return typeof widget.getFacets == 'function';
            })
            .reduce(
                function(acc, widget) {
                    return widget.getFacets(acc);
                },
                {}
            );
    },

    setHash: function(force) {

        var me = this,
            mergedValues = me.getMergedValues();

        var json = JSON.stringify(mergedValues);
        var hash = encodeURIComponent(json);

        window.location.hash = hash;

        if (force) {
            me.hashChanged();
        }
    },

    hashChanged: function() {

        var me = this,
            hash = window.location.hash.substring(1, window.location.hash.length);

        var json, values;
        try {
            json = decodeURIComponent(hash);
            values = jQuery.parseJSON(json);
        } catch {
            // Try base64 encoding for backwards compatibility
            json = atob(hash);
            values = jQuery.parseJSON(json);
        }

        // When pages link to the search page with certain filters enabled, facets are not present in the hash, so we add them here.
        // If they would not be added, they would not be requested from the server and they cannot be displayed.
        values.facets = this.getMergedFacets();

        $.proxy(me.setWidgetsState(values), me);

        if (me.blankSearchStarted && me.searchOnLoad == false) {
            return false;
         }

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

    setFacets: function(facets) {
        if (typeof facets !== 'object') {
            facets = JSON.parse(facets);
        }

        $.each(this.getWidgets(), function(i, widget) {
            if (widget.setFacets && typeof widget.setFacets == 'function') {
                widget.setFacets(facets);
            }
        });
    },

    doSearch: function(values) {
        var me = this;
        $(document).trigger("search:doSearchWire", {
            'values': values
        });
    },

    toggleSearchOptions: function(forceClose) {

        var el = $('.search__filters');

        if (!forceClose) {
            el.toggleClass('is-open');
        } else {
            el.removeClass('is-open');
        }

    },

    toggleSearchSection: function(title) {
        title.closest('.search__filters__section').toggleClass('is-open');
    }

});
