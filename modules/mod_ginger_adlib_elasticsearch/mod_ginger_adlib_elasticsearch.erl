%% @doc Zotonic/Adlib integration
-module(mod_ginger_adlib_elasticsearch).
-author("Driebit <tech@driebit.nl>").

-mod_title("Adlib in Elasticsearch").
-mod_prio(500).
-mod_description("Makes Adlib data searchable by indexing it in Elasticsearch").
-mod_depends([mod_elasticsearch, mod_ginger_adlib]).

-export([
    init/1,
    index/1,
    types/1,
    observe_adlib_update/2
]).

-include_lib("mod_ginger_adlib/include/ginger_adlib.hrl").
-include_lib("zotonic.hrl").

init(Context) ->
    default_config(index, index(Context), Context).

observe_adlib_update(#adlib_update{date = _Date, database = Database, record = #{<<"priref">> := Priref} = Record}, Context) ->
    lager:info("Indexing Adlib record ~s from database ~s", [Priref, Database]),

    MappedRecord = ginger_adlib_elasticsearch_mapper:map(Record, ginger_adlib_elasticsearch_mapping),
    case elasticsearch:put_doc(index(Context), Database, Priref, MappedRecord, Context) of
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

%% @doc Get Elasticsearch types used for Adlib resources
-spec types(z:context()) -> [binary()].
types(Context) ->
    mod_ginger_adlib:enabled_databases(Context).

default_config(Key, Value, Context) ->
    case m_config:get_value(?MODULE, Key, Context) of
        undefined ->
            m_config:set_value(?MODULE, Key, Value, Context);
        _ ->
            ok
    end.
