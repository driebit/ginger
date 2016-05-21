-module(europeana).

-export([
    extract/1
]).

-include_lib("zotonic.hrl").
-include_lib("xmerl/include/xmerl.hrl").

%% Extract DC terms from a string
extract(Xml = #xmlElement{}) ->
    ginger_xml:get_values("//ese:*", Xml).
