mod_ginger_dbpedia_spotlight
============================

A Zotonic module for the [DBpedia Spotlight](http://www.dbpedia-spotlight.org)
[API](http://www.dbpedia-spotlight.org/api) to recognize DBpedia resources in  
text.

This module is part of [Ginger](http://github.com/driebit/ginger).

Features:

* client for the DBpedia Spotlight API
* notification for producing resource text that will be used for entity recognition.

Configuration
-------------

If you use your own DBpedia Spotlight server, you can configure that:

```erlang
m_config:set_value(mod_ginger_dbpedia_spotlight, endpoint, <<"http://yourinstance.local/rest">>, Context).
```

Usage
-----

## Notifications

### rsc_entity_text

This notification is sent to determine which texts to use for entity 
recognition.

```erlang
-export([
    observe_rsc_entity_text/3
]).

-include_lib("mod_ginger_dbpedia_spotlight/include/ginger_dbpedia_spotlight.hrl").

observe_rsc_entity_text(#rsc_entity_text{id = Id}, Acc, Context) ->
    ExtraText = z_trans:trans(m_rsc:p(Id, extra_text, Context), Context),
    [ExtraText | Acc].    
```
