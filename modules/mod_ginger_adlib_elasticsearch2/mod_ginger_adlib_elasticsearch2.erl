%% @doc Zotonic/Adlib integration
-module(mod_ginger_adlib_elasticsearch2).
-author("Driebit <tech@driebit.nl>").

-mod_title("Adlib in ElasticSearch").
-mod_prio(500).
-mod_description("Makes Adlib data searchable by indexing it in ElasticSearch (v7+)").
-mod_depends([mod_elasticsearch2, mod_ginger_adlib]).
-mod_schema(1).

-export([
    init/1,
    index/1,
    types/1,
    manage_schema/2,
    observe_adlib_update/2
]).

-include_lib("mod_ginger_adlib/include/ginger_adlib.hrl").
-include_lib("zotonic.hrl").

init(Context) ->
    default_config(index, index(Context), Context),
    prepare_elasticsearch_index(Context).

manage_schema(_, Context) ->
    prepare_elasticsearch_index(Context).

%% @doc Create index and mappings for each type in the index.
-spec prepare_elasticsearch_index(z:context()) -> ok.
prepare_elasticsearch_index(Context) ->
    {Version, Mapping} = ginger_adlib_elasticsearch2_index_mapping:default_mapping(Context),
    {ok, _} = elasticsearch2_index:upgrade(index(Context), Mapping, Version, Context),
    ok.

observe_adlib_update(#adlib_update{date = _Date, database = Database, record = #{<<"@attributes">> := #{<<"priref">> := Priref}} = Record}, Context) ->
    lager:debug("Indexing Adlib record ~s from database ~s", [Priref, Database]),
    MappedRecord = ginger_adlib_elasticsearch2_mapper:map(Record, ginger_adlib_elasticsearch_mapping),
    MappedRecord1 = MappedRecord#{
        <<"es_type">> => Database
    },
    case elasticsearch2:put_doc(index(Context), Priref, MappedRecord1, Context) of
        {ok, _} ->
            ok;
        {error, Message} ->
            lager:error("Record with priref ~s from database ~p could not be saved to Elasticsearch: ~p", [Priref, Database, Message])
    end.

%% @doc Get Elasticsearch index name for Adlib resources
-spec index(z:context()) -> binary().
index(Context) ->
    Default = <<(elasticsearch2:index(Context))/binary, "_adlib">>,
    case m_config:get_value(mod_ginger_adlib_elasticsearch2, index, Context) of
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
