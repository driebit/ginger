$.widget('ui.search_cmp_filter_terms', {
    _create: function() {
        var me = this,
            widgetElement = $(me.element);

        me.widgetElement = widgetElement;
        me.property = widgetElement.data('property');
        me.propertyPath = widgetElement.data('property-path');
        me.key = (me.propertyPath) ? me.propertyPath + '.' + me.property : me.property;
        me.updateEvent = widgetElement.data('update-event');
        me.dynamic = widgetElement.data('dynamic');
        me.globalCount = widgetElement.data('global-count');
        me.sortByCount = widgetElement.data('sort-by-count');
        me.size = widgetElement.data('size');

        widgetElement.on('change', function () {
            $(document).trigger('search:inputChanged');
        });
    },

    getValues: function() {
        var me = this,
            inputs = me.widgetElement.find('input:checked'),
            values;

        values = $.map(inputs, function(input) {
            return $(input).val();
        });

        return [{
            'type': this.key,
            'values': values
        }];
    },

    setValues: function(values) {
        this.values = values[this.key];
    },

    getFacets: function(facets) {
        const facet = this.withPropertyPath(
            {
                'terms': this.withSize(
                    this.withSort(
                        {'field': this.key}
                    )
                )
            },
            this.propertyPath
        );

        facets[this.key] = facet;

        if (!this.dynamic) {
            // Fixed (global) facet, so add globally scoped facet: the full
            // list, not scoped to the current search query but based on all
            // data.
            facets[this.key + '_global'] = {
                'global': {
                    'aggs': {
                        'global_term_agg': facet
                    }
                }
            };
        }

        return facets;
    },

    setFacets: function(facets) {
        if (facets[this.key]) {
            const facet = facets[this.key];
            const localBuckets = this.getBuckets(facet);

            // Re-render the options template
            z_event(this.updateEvent, {
                'local_buckets': localBuckets,
                'global_buckets': this.getGlobalBuckets(localBuckets, facets),
                'values': this.values || this.getValues()[0].values
            });
        }
    },

    withPropertyPath: function (facet, propertyPath) {
        if (!propertyPath) {
            return facet;
        }

        // Wrap facet in nested aggregation.
        return {
            'nested': {
                'path': propertyPath
            },
            'aggs': {
                'nested_agg': facet
            }
        };
    },

    // Add aggregation size
    withSize: function (facet) {
        if (this.size) {
            facet.size = this.size;
        }

        return facet;
    },

    // Add aggregation sort
    withSort: function (facet) {
        if (this.sortByCount) {
            // Sorting by count is the default search order
            return facet;
        }

        // Sort by key (term)
        facet.order = {'_term': 'asc'};

        return facet;
    },

    getBuckets: function (facet) {
        if (facet.nested_agg) {
            return facet.nested_agg.buckets;
        }

        return facet.buckets;
    },

    getGlobalBuckets: function (localBuckets, facets) {
        if (facets[this.key + '_global']) {
            // Global aggregation: return local counts with the global buckets
            const globalBucketCounts = this.getBuckets(facets[this.key + '_global'].global_term_agg);

            return globalBucketCounts.map(function (bucket) {
                return this.withDocCount(bucket, localBuckets);
            }.bind(this));
        }

        return {};
    },

    withDocCount: function (bucket, localBuckets) {
        if (this.globalCount) {
            // Global doc counts, so use those from global aggregations.
            return bucket;
        }

        // Look in localBuckets for local doc counts.
        const matchingLocalBucket = localBuckets.find(function (localBucket) {
            return localBucket.key === bucket.key;
        });

        if (matchingLocalBucket) {
            bucket.doc_count = matchingLocalBucket.doc_count;
        } else {
            bucket.doc_count = 0;
        }

        return bucket;
    },
});

