$.widget('ui.search_cmp_filter_terms', {
    _create: function() {
        let me = this,
            widgetElement = $(me.element);

        me.widgetElement = widgetElement;
        me.property = widgetElement.data('property');
        me.updateEvent = widgetElement.data('update-event');
        me.dynamic = widgetElement.data('dynamic');
        me.sortByCount = widgetElement.data('sort-by-count');

        widgetElement.on('change', function () {
            $(document).trigger('search:inputChanged');
        });
    },

    getValues: function() {
        let me = this,
            inputs = me.widgetElement.find('input:checked'),
            values;

        values = $.map(inputs, function(input) {
            return $(input).val();
        });

        return [{
            'type': this.property,
            'values': values
        }];
    },

    setValues: function(values) {

    },

    getFacets: function(facets) {
        // Add local (search result-based) facet for document counts
        if (!this.sortByCount) {

        }

        let facet = this.withSort({
            'field': this.property,
            'size': 100
        });
        facets[this.property] = facet;

        if (!this.dynamic) {
            // Fixed (global) facet, so add globally scoped facet: the full
            // list, not scoped to the current search query but based on all
            // data.
            facets[this.property + '_global'] = {
                'global': {
                    'aggs': {
                        'global_term_agg': {
                            'terms': facet
                        }
                    }
                }
            };
        }

        return facets;
    },

    setFacets: function(facets) {
        if (facets[this.property]) {
            let localBuckets = facets[this.property].buckets;
            let globalBuckets = {};

            if (facets[this.property + '_global']) {
                // Global aggregation: return local counts with the global
                // buckets

                let globalBucketCounts = facets[this.property + '_global'].global_term_agg.buckets;
                globalBuckets = globalBucketCounts.map(function (bucket) {
                    let matchingLocalBuckets = localBuckets.filter(function (localBucket) {
                        return localBucket.key === bucket.key;
                    });
                    if (matchingLocalBuckets.length > 0) {
                        bucket.doc_count = matchingLocalBuckets[0].doc_count;
                    } else {
                        bucket.doc_count = 0;
                    }

                    return bucket;
                });
            }

            // Re-render the options template
            z_event(this.updateEvent, {
                'local_buckets': localBuckets,
                'global_buckets': globalBuckets,
                'values': this.getValues()[0].values
            });
        }
    },

    withSort: function (facet) {
        if (this.sortByCount) {
            // Sorting by count is the default search order
            return facet;
        }

        // Sort by key (term)
        facet.order = {'_term': 'asc'};

        return facet;
    },
});

