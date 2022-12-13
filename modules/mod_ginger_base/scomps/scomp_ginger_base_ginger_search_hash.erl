-module(scomp_ginger_base_ginger_search_hash).
-behaviour(gen_scomp).
-export([vary/2, render/3]).
-include_lib("zotonic.hrl").

vary(_Params, _Context) -> nocache.

% Scomp for linking to search pages with some filters enabled.
% Example: `<a href="{{ m.rsc.knowledgebase_query.page_url }}#{% ginger_search_hash hassubjects=[blk.rsc_id] type="list"|to_binary %}">`
% Note that adding a `type` is required
render(Params, _Vars, Context) ->
    Hash = filter_urlencode:urlencode(jsx:encode(maps:from_list(Params)), Context),
    {ok, z_render:render(Hash, Context)}.
