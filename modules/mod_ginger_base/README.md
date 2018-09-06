mod_ginger_base
===============

A Zotonic module that adds basic Ginger templates, search and other features.

This module is part of [Ginger](http://github.com/driebit/ginger).

Features:

* basic Ginger templates that offer building blocks for creating sites.
* additional search arguments.

Usage
-----

## Ginger Search

This module adds a custom search type (`ginger_search`) with extra search
arguments for more advanced searches. Each argument is described below.

### boost_featured

Boost result ranking for featured resources, i.e. resources for which 
`is_featured` is true:

```erlang
z_search:search({ginger_search, [{text, <<"foo">>}, {boost_featured, true}]}, Context).
```

or:

```erlang
z_search:search({ginger_search, [{text, <<"foo">>}, {boost_featured, false}]}, Context).
```

Defaults to `true`. 

Only works on [Elasticsearch](https://github.com/driebit/mod_elasticsearch). 

### cat_promote

Boost result ranking for resources that are in specific categories. So, to move
person resources up in the search result rankings:

```erlang
z_search:search({ginger_search, [{text, <<"foo">>}, {cat_promote, [person]}]}, Context).
```

Only works on [Elasticsearch](https://github.com/driebit/mod_elasticsearch).

### cat_promote_recent

Boost result ranking for resources that are in specific categories. So, to make
recent articles more relevant: 

```erlang
z_search:search({ginger_search, [{text, <<"foo">>}, {cat_promote_recent, [person, article]}]}, Context).
```

Defaults to `[article]`.

Only works on [Elasticsearch](https://github.com/driebit/mod_elasticsearch).

### has_geo

Only return search results that have geo coordinates:

```erlang
z_search:search({ginger_search, [{has_geo, true}]}, Context).
```

Only return search results that have no geo coordinates:

```erlang
z_search:search({ginger_search, [{has_geo, false}]}, Context).
```
