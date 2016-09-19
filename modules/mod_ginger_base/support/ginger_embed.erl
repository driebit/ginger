%% Ginger embeds based on RDF data
-module(ginger_embed).
-author("Driebit <tech@driebit.nl>").

%% API
-export([
    is_ginger_embed/1
]).

%% @doc Is the related media page a Ginger embed?
-spec is_ginger_embed([tuple()]) -> boolean().
is_ginger_embed(Props) ->
    proplists:get_value(video_embed_service, Props) =:= <<"ginger">>.
