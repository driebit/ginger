-module(controller_rest).

-export([ meck_map_lookup/3
        , setup_cleanup/1
        ]
       ).

%%%-----------------------------------------------------------------------------
%%% Test utils
%%%-----------------------------------------------------------------------------

meck_map_lookup(Mod, Fun, Map) ->
    Get = fun (Binding, _Req) -> maps:get(Binding, Map, undefined) end,
    meck:expect(Mod, Fun, Get).

setup_cleanup(Modules) ->
    Setup = fun () -> lists:foreach(fun meck:new/1, Modules) end,
    Cleanup = fun (_) -> lists:foreach(fun meck:unload/1, lists:reverse(Modules)) end,
    {Setup, Cleanup}.
