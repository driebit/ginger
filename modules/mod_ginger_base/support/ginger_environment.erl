%% @doc Get information about current environment based on configured hostname
-module(ginger_environment).
-author("Driebit <tech@driebit.nl").

-export([
    get/1,
    is_dev/1,
    is_acc/1,
    is_prod/1
]).

-include_lib("zotonic.hrl").

%% @doc Get current environment
-spec get(#context{}) -> dev|acc|prod.
get(Context) ->
    case is_dev(Context) of
        true -> dev;
        false ->
            case is_acc(Context) of
                true -> acc;
                false -> prod
            end
    end.


is_dev(Context) ->
    match(".(test|ginger-test.driebit.net|test.ginger-review.driebit.net)$", Context).

is_acc(Context) ->
    match(".(ginger-acceptatie.driebit.net|acceptance.ginger-review.driebit.net)$", Context).

is_prod(Context) ->
    case ginger_environment:get(Context) of
        prod -> true;
        _ -> false
    end.

match(Pattern, Context) ->
    Hostname = z_context:hostname(Context),
    case re:run(Hostname, Pattern) of
        {match, _} ->
            true;
        nomatch ->
            false
    end.
