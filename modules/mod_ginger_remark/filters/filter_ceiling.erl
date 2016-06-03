%% @author Driebit <info@driebit.nl>
%% @copyright 2015 Driebit
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

-module(filter_ceiling).
-author("Driebit <info@driebit.nl>").
-export([ceiling/2]).
-include("zotonic.hrl").

ceiling(Number, _Context) when Number < 0 ->
    trunc(Number);
ceiling(Number, _Context) ->
    T = trunc(Number),
    case Number - T == 0 of
        true -> T;
        false -> T + 1
    end.