%% @doc Zotonic/Adlib integration
-module(mod_ginger_adlib_elasticsearch).
-author("Driebit <tech@driebit.nl>").

-mod_title("Adlib in Elasticsearch").
-mod_prio(500).
-mod_description("Makes Adlib data searchable by indexing it in Elasticsearch").
-mod_depends([mod_elasticsearch, mod_ginger_adlib]).

-export([
    observe_adlib_update/2
]).

-include_lib("mod_ginger_adlib/include/ginger_adlib.hrl").
-include_lib("zotonic.hrl").

observe_adlib_update(#adlib_update{date = _Date, database = Database, record = #{<<"priref">> := Priref} = Record}, Context) ->
    MappedRecord = ginger_adlib_elasticsearch_mapping:map(Record),
    lager:info("Indexing Adlib record ~s", [Priref]),
    case erlastic_search:index_doc_with_id(index(Context), Database, Priref, MappedRecord) of
        {ok, _} ->
            ok;
        {error, Message} ->
            lager:error("Record with priref ~p could not be saved to Elasticsearch: ~p", [Priref, Message])
    end.

%% @doc Get Elasticsearch index name for Adlib resources
-spec index(z:context()) -> binary().
index(Context) ->
    Default = <<(elasticsearch:index(Context))/binary, "_adlib">>,
    case m_config:get_value(mod_ginger_adlib_elasticsearch, index, Context) of
        undefined -> Default;
        <<>> -> Default;
        Value -> z_convert:to_binary(Value)
    end.
