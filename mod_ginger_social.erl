%% @author Driebit <info@driebit.nl>
%% @copyright 2014

-module(mod_ginger_social).
-author("Driebit <info@driebit.nl>").

-mod_title("Ginger social").
-mod_description("Provides handling of feeds from social networks").
-mod_prio(200).
-mod_schema(1).
-mod_depends([authentication]).

-export([
    observe_import_resource/2,

    manage_schema/2
    ]).

-include_lib("zotonic.hrl").

observe_import_resource(#import_resource{
                            source = Source,
                            source_id = SourceId,
                            source_url = SourceUrl,
                            source_user_id = SourceUserId,
                            user_id = UserId,
                            name = UniqueName,
                            props = ImportProps,
                            media_urls = MediaUrls,
                            urls = LinkUrls,
                            data = Data
                          },
                          Context) ->
    case {
        exists(UniqueName, Context),
        is_original_content(Source, Data),
        z_convert:to_bool(m_config:get_value(mod_ginger_social, import_enabled, Context))
    } of
        {false, true, true} ->
            AdminContext = z_acl:sudo(Context),
            GingerProps = [
                    {name, UniqueName},
                    {category, feed_category(Source)},
                    {creator_id, UserId},
                    {is_published, is_published(UserId, Context)},
                    {posting_data, {raw, [
                        {source, Source},
                        {source_id, SourceId},
                        {source_user_id, SourceUserId},
                        {source_url, SourceUrl}
                    ]}},
                    {title, extract_title(Source, ImportProps)},
                    {short_title, username(Source, Data)},
                    {source_user_url, user_url(Source, Data)},
                    {source_user_thumbnail_url, user_thumbnail_url(Source, Data)},
                    {source_user_name_full, user_name_full(Source, Data)},
                    {source_post_url, SourceUrl}
                ] ++ fetch_website(Source, SourceId, Data),
            RscProps = z_utils:props_merge(GingerProps, ImportProps),
            Result = case first_media_props(MediaUrls ++ LinkUrls, Context) of
                        {ok, MI} ->
                            z_media_import:insert(MI#media_import_props{rsc_props=RscProps}, AdminContext);
                        {error, _} ->
                            m_rsc:insert(RscProps, AdminContext)
                     end,
            lager:debug("[~p] Ginger Social: imported posting ~p:~p for user_id ~p as ~p", 
                        [z_context:site(Context), Source, SourceId, UserId, Result]),
            ok;
        {_, _, false} ->
            lager:info("[~p] Ginger Social: import disabled, dropped posting ~p:~p", 
                       [z_context:site(Context), Source, SourceId]),
            ok;
        {_, false, _} ->
            % Prevent duplicate and unwanted imports
            lager:info("[~p] Ginger Social: dropped post with reposted content ~p:~p", 
                       [z_context:site(Context), Source, SourceId]),
            ok;
        {true, _, _} ->
            % Prevent duplicate and unwanted imports
            lager:info("[~p] Ginger Social: dropped duplicate posting ~p:~p", 
                       [z_context:site(Context), Source, SourceId]),
            ok
    end.

extract_title(_Source, ImportProps) ->
    case proplists:get_value(body, ImportProps) of
        undefined ->
            proplists:get_value(title, ImportProps);
        {trans, []} ->
            proplists:get_value(title, ImportProps);
        Body ->
            truncate_title(Body)
    end.

truncate_title(undefined) ->
    undefined;
truncate_title({trans, Tr}) ->
    {trans, [ {Iso, truncate_title(T)} || {Iso, T} <- Tr ]};
truncate_title(B) ->
    z_string:truncate(z_html:strip(B), 50).

username(instagram, Data) ->
    v(<<"username">>, v(<<"user">>, Data));
username(twitter, Data) ->
    v(<<"screen_name">>, v(<<"user">>, Data));
username(_Source, _Date) ->
    undefined.

user_name_full(instagram, Data) ->
    v(<<"full_name">>, v(<<"user">>, Data));
user_name_full(twitter, Data) ->
    v(<<"name">>, v(<<"user">>, Data));
user_name_full(_Source, _Date) ->
    undefined.

user_url(instagram, Data) ->
    case v(<<"username">>, v(<<"user">>, Data)) of
        undefined -> 
            undefined;
        Username -> 
            iolist_to_binary([ <<"https://instagram.com/">>, Username ])
    end;
user_url(twitter, Data) ->
    case v(<<"screen_name">>, v(<<"user">>, Data)) of
        undefined ->
            undefined;
        Username -> 
            iolist_to_binary([ <<"https://twitter.com/">>, Username ])
    end;
user_url(_Source, _Date) ->
    undefined.

user_thumbnail_url(instagram, Data) ->
    v(<<"profile_picture">>, v(<<"user">>, Data));
user_thumbnail_url(twitter, Data) ->
    v(<<"profile_image_url_https">>, v(<<"user">>, Data));
user_thumbnail_url(_Source, _Date) ->
    undefined.

v(_P, undefined) ->
    undefined;
v(P, {struct, Ps}) ->
    v(P, Ps);
v(P, {Ps}) ->
    v(P, Ps);
v(P, Ps) ->
    case proplists:get_value(P, Ps) of
        null -> undefined;
        V -> V
    end.

is_published(UserId, Context) ->
    is_published_config(UserId, m_config:get_value(mod_ginger_social, publish_known, Context)).

is_published_config(_UserId, <<"all">>) -> true;
is_published_config(UserId, <<"known">>) -> is_integer(UserId);
is_published_config(_UserId, _Config) -> false.

first_media_props([], _Context) ->
    {error, nomedia};
first_media_props([Url|Urls], Context) ->
    case z_media_import:url_import_props(Url, Context) of
        {ok, []} ->
            first_media_props(Urls, Context);
        {ok, [MI|_]} -> 
            {ok, MI};
        {error, _} ->
            first_media_props(Urls, Context)
    end.

exists(undefined, _Context) -> false;
exists(Name, Context) -> m_rsc:exists(Name, Context).

feed_category(twitter) -> twitter;
feed_category(facebook) -> facebook;
feed_category(instagram) -> instagram;
feed_category(_) -> feedimport.

is_original_content(twitter, Data) ->
    not is_retweet(proplists:get_value(<<"text">>, Data));
is_original_content(_Service, _Data) ->
    true.

is_retweet(<<"RT ", _/binary>>) -> true;
is_retweet(<<"MT ", _/binary>>) -> true;
is_retweet(<<" ", Text/binary>>) -> is_retweet(Text);
is_retweet(<<>>) -> true;
is_retweet(_) -> false.

fetch_website(twitter, TweetId, Data) ->
    {User} = proplists:get_value(<<"user">>, Data),
    ScreenName = proplists:get_value(<<"screen_name">>, User),
    TweetUrl = iolist_to_binary([
            "https://twitter.com/", ScreenName, "/status/", z_convert:to_binary(TweetId)
        ]),
    [{website, TweetUrl}];
fetch_website(_, _, _) ->
    [].


manage_schema(_, _Context) ->
    #datamodel{
        categories=[
            {feed, undefined, [
                {title, {trans, [{nl, <<"Feed">>}, {en, <<"Feed">>}]}}
            ]},
                {twitter, feed, [
                    {title, {trans, [{nl, <<"Twitter">>}, {en, <<"Twitter">>}]}}
                ]},
                {facebook, feed, [
                    {title, {trans, [{nl, <<"Facebook">>}, {en, <<"Facebook">>}]}}
                ]},
                {instagram, feed, [
                    {title, {trans, [{nl, <<"Instagram">>}, {en, <<"Instagram">>}]}}
                ]},
                {feedimport, feed, [
                    {title, {trans, [{nl, <<"Van feed">>}, {en, <<"From Feed">>}]}}
                ]}
        ]
    }.
