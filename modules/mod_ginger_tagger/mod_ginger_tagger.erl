%% @author Driebit <tech@driebit.nl>
%% @copyright 2015

-module(mod_ginger_tagger).
-author("Driebit <tech@driebit.nl>").

-mod_title("Tagger").
-mod_description("RFID actions for Zotonic").
-mod_prio(500).
-mod_schema(0).

-include_lib("zotonic.hrl").
-include_lib("include/tagger.hrl").

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

%% @doc Link users to media in which they are depicted.
-spec observe_tagger_action(#tagger_action{}, #context{}) -> ok.
observe_tagger_action(#tagger_action{media=Media, users=Users}, Context) ->
    lists:foreach(
        fun(User) ->
            Predicate = m_rsc:uri_lookup("http://xmlns.com/foaf/0.1/depiction", Context),
            m_edge:insert(User, Predicate, Media, Context)
        end,
        Users
    ).
