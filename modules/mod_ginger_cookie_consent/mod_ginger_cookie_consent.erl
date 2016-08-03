%% @doc This module ...
-module(mod_ginger_cookie_consent).
-author("Driebit <tech@driebit.nl>").

-mod_title("Cookie Consent").
-mod_description("Integrates Silktide's Cookie Consent with Zotonic").
-mod_prio(500).
-mod_schema(1).

-include("zotonic.hrl").

-export([
    manage_schema/2
]).

-spec manage_schema(tuple() | atom(), #context{}) -> #datamodel{}.
manage_schema(_, _Context) ->
    #datamodel{
        resources = [
            {cookie_policy, text, [
                {title, {trans, [
                    {nl, <<"Cookieverklaring">>},
                    {en, <<"Cookie policy">>}
                ]}},
                {body, {trans, [
                    {nl, <<"Typ hier je cookieverklaring. Publiceer deze pagina om een link te maken vanuit het cookiebericht.">>},
                    {en, <<"Enter your cookie policy here. Publish this page to link to it from the cookie message.">>}
                ]}},
                {protected, false},
                {is_published, false}
            ]}
        ]
    }.
