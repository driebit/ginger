%% @doc Zotonic/Adlib integration
-module(mod_ginger_adlib_elasticsearch).
-author("Driebit <tech@driebit.nl>").

-mod_title("Adlib").
-mod_prio(500).
-mod_description("Makes Adlib data searchable by indexing it in Elasticsearch").
-mod_depends([mod_elasticsearch, mod_ginger_adlib]).

-export([
    observe_adlib_update/2
]).

-include_lib("mod_ginger_adlib/include/ginger_adlib.hrl").
-include_lib("zotonic.hrl").

observe_adlib_update(#adlib_update{date = _Date, database = Database, record = #{<<"priref">> := Priref} = Record}, Context) ->
    ?DEBUG(Record),
    ?DEBUG(erlastic_search:index_doc_with_id(index(Context), Database, Priref, Record)).

%% @doc Get Elasticsearch index name for Adlib resources
-spec index(z:context()) -> binary().
index(Context) ->
    Default = <<(elasticsearch:index(Context))/binary, "_adlib">>,
    case m_config:get_value(mod_ginger_adlib_elasticsearch, index, Context) of
        undefined -> Default;
        <<>> -> Default;
        Value -> z_convert:to_binary(Value)
    end.
