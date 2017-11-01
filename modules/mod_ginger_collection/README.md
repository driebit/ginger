mod_ginger_collection
=====================

A Zotonic module for displaying linked data collections (datasets) and making 
them searchable through Elasticsearch.

This module is part of [Ginger](http://github.com/driebit/ginger).

Features:

* dynamic faceted search
* linked data mappings for consistency

Installation
------------

This module relies on [mod_elasticsearch](https://github.com/driebit/mod_elasticsearch)
for indexing the linked data, so make sure to install that module first.

After starting the module, on the admin modules page, configure the 
Elasticsearch index that contains the collection documents. The index name
defaults to sitename_collection.

Usage
-----

## Mappings

This module’s templates assume the following linked data predicates:

TODO

## Notifications

Observe `#acl_is_allowed{action = view, object = Object}` to grant or deny 
access to collection items; `Object` is the collection item represented as an
Erlang map:

```erlang
observe_acl_is_allowed(#acl_is_allowed{action = view, object = Object}, Context) when is_map(Object) ->
    %% Return true, false or undefined...;
observe_acl_is_allowed(#acl_is_allowed{}, _Context) ->
    undefined.
````
