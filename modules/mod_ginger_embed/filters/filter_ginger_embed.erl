%% @doc Support for Ginger embeds based on RDF data
-module(filter_ginger_embed).

-export([
    ginger_embed/2
]).

-include("zotonic.hrl").

%% @doc Add script and CSS tag to <ginger-embed>.
%%      This is a bit of a hack. It's easier, however, than allowing the
%%      <script> and <link> tags (in both TinyMCE and z_sanitize), particularly
%%      because while script URLs need to be whitelisted, Ginger embeds must
%%      work for all Ginger site URLs.
-spec ginger_embed(binary(), #context{}) -> binary().
ginger_embed(Input, _Context) ->
    %% Find site URL
    {match, [Url]} = re:run(Input, <<"<a href=\"(https?://[^/]+)">>, [{capture, all_but_first, binary}]),
    Replacement = <<"<script src=\"", Url/binary, "/embed/embed.js\"></script><link href=\"", Url/binary, "/embed/embed.css\" type=\"text/css\" media=\"all\" rel=\"stylesheet\"><ginger-embed">>,
    binary:replace(Input, <<"<ginger-embed">>, Replacement).
