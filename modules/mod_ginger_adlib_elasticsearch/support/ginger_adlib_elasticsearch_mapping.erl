-module(ginger_adlib_elasticsearch_mapping).
-author("david").


-export([]).

-callback map({Property, Value}) -> {Property, Value}.
