%% @author Driebit <info@driebit.nl>
%% @copyright 2015 Driebit
%% @doc unique filter, return a list with unique ids
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(filter_mailencode).
-author("Driebit <info@driebit.nl>").
-export([mailencode/2]).
-include("zotonic.hrl").

rot13(List) ->
    F = fun(C) when (C >= $A andalso C =< $M); (C >= $a andalso C =< $m) -> C + 13;
           (C) when (C >= $N andalso C =< $Z); (C >= $n andalso C =< $z) -> C - 13;
           (C) -> C
        end,
    lists:map(F, List).

mailencode(Address, _Context) ->
    rot13(z_convert:to_list(Address)).
