mod_ginger_rdf
==============

A Zotonic module for retrieving, working with, and producing RDF triples. 

Usage
-----

This module still in an experimental phase. More documentation will be added
later.

Notifications
-------------

On `rsv_pivot_done`, the RDF module will send a `find_links` notification. You 
can subscribe to this notifcation to enrich Zotonic resources with RDF links
to external resources. You should return a list of `#triple` records from your
observer.

```erlang
-export([
    observe_find_links/2
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
