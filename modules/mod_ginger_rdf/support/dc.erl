-module(dc).

-export([
    extract/1
]).

-include_lib("zotonic.hrl").
-include_lib("xmerl/include/xmerl.hrl").

%% Extract DC terms from XML 
extract(Xml = #xmlElement{}) ->
%%     ?DEBUG(ginger_xml:get_value("//dc:*", Xml))
    lists:map(
        fun(#xmlElement{name=Name, content=[#xmlText{value=Value}]}) ->
            {Name, Value}
        end,
        xmerl_xpath:string("//dc:*", Xml)
    ) ++
    lists:map(
        fun(#xmlElement{name=Name, content=[#xmlText{value=Value}]}) ->
            {Name, Value}
        end,
        xmerl_xpath:string("//dcterms:*", Xml)
    );

extract(String) ->
    ?DEBUG(String),
%%     ?DEBUG(length(xmerl_xpath:string("//", String))),
    ?DEBUG(length(xmerl_xpath:string("//dc:description", String))).
%%     ginger_xml:get_value("http://purl.org/dc/elements/1.1/", String).
    
    
    
