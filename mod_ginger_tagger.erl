%% @author Driebit <tech@driebit.nl>
%% @copyright 2015

-module(mod_ginger_tagger).
-author("Driebit <tech@driebit.nl>").

-mod_title("Tagger").
-mod_description("RFID actions for Zotonic").
-mod_prio(500).
-mod_schema(0).

-include_lib("zotonic.hrl").
-include("include/tagger.hrl").

-export([
    manage_schema/2,
    observe_tagger_action/2
]).

manage_schema(install, Context) ->
    Datamodel = #datamodel{
        categories = [
            {rfid_device, undefined, [{title, <<"RFID-scanner">>}]}
        ],
        predicates = [
            {located_at, [{title, <<"Location">>}], [
                {rfid_device, location}
            ]}
        ]
    },
    z_datamodel:manage(?MODULE, Datamodel, Context),
    ok.

%% @doc Look up RFID identity, and link its user to the media item.
-spec observe_tagger_action(#tagger_action{}, #context{}) -> ok.
observe_tagger_action(#tagger_action{media=Media, rfids=Rfids}, Context) ->
    %% Create edges from users to the media
    ?DEBUG(Rfids),
    lists:foreach(
        fun(Rfid) ->
            case m_identity:lookup_by_type_and_key(rfid, Rfid, Context) of
                undefined ->
                    %% RFID identity not found; ignore
                    noop;
                Identity ->
                    UserId = proplists:get_value(rsc_id, Identity),
                    Predicate = m_rsc:uri_lookup("http://xmlns.com/foaf/0.1/depiction", Context),
                    m_edge:insert(UserId, Predicate, Media, Context)
            end
        end,
        Rfids
    ).
