-module(controller_rest).

-export([ setup_cleanup/1
        ]
       ).

%%%-----------------------------------------------------------------------------
%%% Test utils
%%%-----------------------------------------------------------------------------

setup_cleanup(Modules) ->
    Setup = fun () -> lists:foreach(fun meck:new/1, Modules) end,
    Cleanup = fun (_) -> lists:foreach(fun meck:unload/1, lists:reverse(Modules)) end,
    {Setup, Cleanup}.
