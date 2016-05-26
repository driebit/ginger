%% @doc Decode JSON request body
-module(ginger_json).
-author("Driebit <tech@driebit.nl").

-export([
    decode/1
]).

-include_lib("zotonic.hrl").

%% @doc Decode JSON request body
% @todo Replace JSON decoding with https://github.com/zotonic/zotonic/pull/942
% when merged.
-spec decode(#wm_reqdata{}) -> {error, atom(), string()} | list().
decode(ReqData) ->
    {ReqBody, _RD} = wrq:req_body(ReqData),
    case ReqBody of 
        <<>> -> {error, syntax, "Empty JSON request body"};
        NonEmptyBody ->
            Json = try 
                mochijson2:decode(NonEmptyBody)
            catch
                Type -> {error, Type}
            end,

            case Json of 
                {error, Error} -> {error, syntax, Error};
                {struct, JsonBody} -> JsonBody
            end
    end.
