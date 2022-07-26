%% @author Driebit <info@driebit.nl>
%% @copyright 2015 Driebit
%% @doc Check if a resource has a location_lat defined.
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

-module(filter_location_defined).
-author("Driebit <info@driebit.nl>").
-export([location_defined/2]).
-include("zotonic.hrl").

has_location(undefined, _Context) ->
    false;
has_location(RscId, Context) when is_integer(RscId) ->
    case m_rsc:p(RscId, location_lat, Context) of
        undefined ->
            false;
        <<>> ->
            false;
        _Lat ->
            true
    end;
has_location({RscId, _}, Context) ->
    has_location(RscId, Context);
has_location(RscId, Context) ->
    has_location(m_rsc:rid(RscId, Context), Context).

location_defined(Data, Context) ->
    List = filter_make_list:make_list(Data, Context),
    lists:filter(
        fun(Item) ->
            has_location(Item, Context)
        end,
        List
    ).

