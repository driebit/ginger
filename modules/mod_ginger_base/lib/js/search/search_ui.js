$.widget("ui.search_ui", {

    _create: function() {

        var me = this;

        $(document).on('widgetmanager:loaded', $.proxy(me.init, this));

        me.source = null;
        me.pager = null;

    },

    init: function() {

        //after all widget's _create function
        var me = this,
            inputSearch = $(document).find('.input-search'),
            queryString = $.url().param('searchterm'),
            documentWidth = $(document).width();

        window.onhashchange = $.proxy(me.hashChanged, me);

        inputSearch.focus();

        $('.search__top__container').find('.btn--result-option').on('click', function() {
            $.proxy(me._toggleView($(this).attr('href').substring(1)), me);
            return false;
        });

        $('.global-search__submit').on('click', function(event) {
            event.preventDefault();
            me.doSearch(true);
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

        if (documentWidth < 1024) {
            $('.global-search__submit').on('click', function() {
                me.toggleSearchOptions();
            });
        }

        me.searched = [];

        me._toggleView('list');

    },

    _toggleView: function(type) {

        var me = this,
            type;

        $('.btn--result-option').removeClass('is-active');

        var buttonEl = $('[href="#' + type + '"]');

        buttonEl.addClass('is-active');
        $('.search__result__container').hide();
        $('#search-' + type).show();
        $('#search-' + type).css('visibility', 'visible');

        if (jQuery.inArray(type, me.searched) == -1) {
            me.hashChanged(true);
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

        //type = me.getType();

        //if (reset) me.searched = [];

        //if (jQuery.inArray(type, me.searched) == -1) me.searched.push(type);


    },

    setHash: function(force) {

        console.log('sethash func');

        //create state hash
        var me = this,
            json = JSON.stringify(me.getMergedValues()),
            hash = btoa(json);

				console.log(json);
        window.location.hash = hash;

        if (force) {
            me.hashChanged();
        }

    },


    hashChanged: function() {

        console.log('hash has changed, in func');

        var me = this,
            hash = window.location.hash.substring(1, window.location.hash.length),
            json = atob(hash),
            values = jQuery.parseJSON(json);


				console.log(values);

        $.proxy(me.setWidgetsState(values), me);
        $.proxy(me.doSearch(values), me);

    },


    setWidgetsState: function(values) {

        var me = this,
            widgets = me.getWidgets();

        $.each(widgets, function(i, widget) {

            if (!widget.setValues || typeof widget.setValues != 'function') return;
            widget.setValues(values);

        });
    },


    doSearch: function(values) {

        var me = this,
            type = me.getType();

        $(document).trigger("search:doSearchWire", {
            'values': values,
            'type': type
        });

    },


    getType: function() {
        var el = $('.btn--result-option.is-active');
        return (el.size() > 0) ? el.attr('href').replace(/#/, '') : false;
    },

    toggleSearchOptions: function() {
        $('.search__filters').toggleClass('is-open');
    },

    toggleSearchSection: function(title) {
        title.parent().siblings().removeClass('is-open');
        title.parent().toggleClass('is-open');
    }

});
