mod_ginger_rdf
==============

A Zotonic module for retrieving, working with, and producing RDF triples. This
module supports both XML and JSON-LD serialization formats.

Features:

* Make all your Zotonic resources available in RDF.
* Relate your Zotonic resources to linked data from other sources.

Represent resources in RDF
--------------------------

Enable mod_ginger_rdf in Zotonic, then request any page with the proper Accept
header to get an RDF representation of the resource (where `123` is the id
of some resource):

```bash
curl -L -H Accept:application/ld+json http://yoursite.com/id/123
```

Only predicates with a URI will be included in the output. If you’re missing
one of your custom predicates, give it the URI of some property in one of the
linked data vocabularies. You can do so in the admin, on the predicate’s edit
page, under ‘Advanced’.

Observe the `#rsc_to_rdf{}` notification to hook into the process:

```erlang
observe_rsc_to_rdf(#rsc_to_rdf{id = Id}, Triples, Context) ->
    Triple = #triple{
        predicate = <<"http://yoursite.com/super-special-predicate">>,
        object = m_rsc:p(Id, some_custom_property, Context)
    },
    [Triple | Triples].
```

This JSON-LD serialization happens in two steps. First, the Zotonic resource
is converted into a set of RDF triples. To do so yourself:

```erlang
-include_lib("mod_ginger_rdf/include/rdf.hrl").

#rdf_resource{id = Id, triples = Triples} = m_rdf:to_triples(Id, Context).
```

Then, the `#rdf_resource{}` record is serialized into a Mochijson-compatible
JSON structure:

```erlang
Resource = m_rdf:to_triples(Id, Context),
JsonLd = ginger_json_ld:serialize(RdfResource),
mochijson2:encode(JsonLd).
```

Please note that currently only the [JSON-LD](https://www.w3.org/TR/json-ld/)
serialization format is supported. Pull requests to add other formats are
very welcome.

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

-include_lib("mod_ginger_rdf/include/rdf.hrl").

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
