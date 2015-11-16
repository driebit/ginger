mod_ginger_rdf
==============

A Zotonic module for retrieving, working with, and producing RDF triples.

Usage
-----

This module still in an experimental phase. More documentation will be added
later.

Notifications
-------------

### Adding links

On `rsv_pivot_done`, the RDF module will send a `find_links` notification. You
can subscribe to this notifcation to enrich Zotonic resources with RDF links
to external resources. You should return a list of `#triple` records from your
observer.

```erlang
-export([
    observe_find_links/3
]).

-include_lib("../../modules/mod_ginger_rdf/include/rdf.hrl").

observe_find_links(#find_links{id=Id, is_a=CatList}, Links, _Context) ->
    %% Do some search to find relevant RDF links, then return them as a list
    %% of triple records:
    [
        %% An outgoing link
        #triple{
            type=resource,
            subject=Id,
            predicate="http://xmlns.com/foaf/0.1/depiction",
            object="http://example.com/some/external/resource.rdf"
        },

        %% An incoming link
        #triple{
            type=resource,
            subject="http://example.com/some/external/resource.rdf",
            predicate="http://xmlns.com/foaf/0.1/depicts",
            object=Id
        }
    | Links ].
```

The mod_ginger_rdf module will then:

* for each RDF resource (subject or object), create a non-authoritative
  Zotonic resource containing the RDF resource URL
* for each RDF link, create an edge between these non-authoritative resources
  and authoritative Zotonic resources.

If the URLs point to real linked data sources, the URL should be sufficient
for further data retrieval. Unfortunately, this is not always the case, so you
may want to store additional properties in either subject or object by adding
`subject_props` or `object_props`:


```erlang
        #triple{
            type=resource,
            subject=Id,
            predicate="http://xmlns.com/foaf/0.1/depiction",
            object="http://example.com/some/external/resource.rdf",
            object_props=[
                {some_extra_id_that_is_needed_for_retrieval, "ID.123.467"}
            ]
        },
```

### On-demand linked data retrieval

On `rsc_get` this module will send a `rdf_get` notification for all
non-authoritative resources that have a URI.

Observe this notification to dynamically retrieve RDF from external data
sources:

```erlang
-export([
    observe_rdf_get/3
]).

%% Props is the set of
observe_rdf_get(#rdf_get{uri=Uri}, Props, _Context) ->
    RdfProperties = do_http_request(Uri),

    %% Return the original (Zotonic) resource properties combined with the
    %% dynamically fetched linked data.
    Props ++ RdfProperties.
```

You can then render the RDF properties in a template:

```dtl
<p>Creator: {{ m.rsc[id]['dc:creator'] }}</p>
<p>Description: {{ m.rsc[id]['dc:description'] }}</p>
```

View models
-----------

### m.rdf

Render RDF properties in your templates:

```dtl
{{ m.rdf[id]['http://purl.org/dc/elements/1.1/title'] }}
```

You can also use certain shortcuts to namespaced RDF properties. For instance:

```dtl
{{ m.rdf[id].thumbnail }}
```

looks at `foaf:thumbnail` first, then `edm:isShownBy`, `schema:image` and
`edm:object` to try to find a suitable value.
