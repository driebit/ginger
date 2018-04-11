%% @doc DBpedia Spotlight is a tool for automatically annotating mentions of
%%      DBpedia resources in text. See http://www.dbpedia-spotlight.org/api.
-module(mod_ginger_dbpedia_spotlight).
-author("Driebit <tech@driebit.nl>").

-mod_title("DBpedia Spotlight").
-mod_description("Find mentions of DBpedia resources in text").
-mod_prio(500).
-mod_depends([mod_ginger_rdf, mod_ginger_base]).

-export([
    annotate/3,
    candidates/3
]).

-include_lib("zotonic.hrl").
-include_lib("include/ginger_dbpedia_spotlight.hrl").
-include_lib("mod_ginger_rdf/include/rdf.hrl").

%% @doc Extract annotation URIs to DBpedia resources from the Zotonic resource's texts.
-spec annotate(m_resource:resource(), atom(), z:context()) -> [map()] | undefined.
annotate(Rsc, Language, Context) ->
    Texts = rsc_entity_text(Rsc, Language, Context),
    ginger_dbpedia_spotlight_client:annotate(Texts, Language).

%% @doc Extract candidate URIs to DBpedia resources from the Zotonic resource's texts.
-spec candidates(m_rsc:resource(), atom(), z:context()) -> [binary()] | undefined.
candidates(Rsc, Language, Context) ->
    Texts = rsc_entity_text(Rsc, Language, Context),
    case ginger_dbpedia_spotlight_client:candidates(Texts, Language) of
        undefined ->
            undefined;
        Candidates ->
            lists:map(fun extract_uri/1, Candidates)
    end.

%% @doc Get texts of and related to the Zotonic resource which will be used for entity extraction.
-spec rsc_entity_text(m_rsc:resource(), atom(), z:context()) -> [binary()].
rsc_entity_text(Rsc, Language, Context) ->
    DefaultTexts = [text(Rsc, P, Language, Context) || P <- [title, subtitle, summary, body]],
    z_notifier:foldl(#rsc_entity_text{id = Rsc, language = Language}, DefaultTexts, Context).

text(Rsc, Property, Language, Context) ->
    z_trans:trans(m_rsc:p(Rsc, Property, Context), Language).

extract_uri(#{<<"resource">> := #{<<"@uri">> := Uri}}) ->
    Uri.