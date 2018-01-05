%% @doc filter to return a css background-position based on crop_center value
-module(filter_background_position).

-export([background_position/2]).

-include("zotonic.hrl").

-spec background_position(integer(), z:context()) -> binary().
background_position(Id, Context) ->
    case m_rsc:p(Id, crop_center, Context) of
        undefined ->
            "center center";
        CropCenter ->
            get_position(Id, CropCenter, Context)
    end.

get_position(Id, CropCenter, Context) ->
    [X,Y] = string:tokens(z_convert:to_list(CropCenter),"+"),
    Medium = m_media:get(Id, Context),
    Width = proplists:get_value(width, Medium),
    Height = proplists:get_value(height, Medium),
    get_background_position(z_convert:to_integer(X), z_convert:to_integer(Y), Width, Height, Context).

get_background_position(_X, _Y, undefined, _Height, _Context) ->
    "center center";
get_background_position(_X, _Y, _Width, undefined, _Context) ->
    "center center";
get_background_position(_X, _Y, undefined, undefined, _Context) ->
    "center center";
get_background_position(X, Y, Width, Height, _Context) ->
    get_x(X, Width)++" "++get_y(Y, Height).

get_x(X, Width)->
    Percentage = (X/Width)*100,
    case Percentage < 34 of
        true ->
            "left";
        false ->
            case Percentage > 66 of
                true ->
                    "right";
                false ->
                    "center"
            end
    end.
get_y(Y, Height)->
    Percentage = (Y/Height)*100,
    case Percentage < 34 of
        true ->
            "top";
        false ->
            case Percentage > 66 of
                true ->
                    "bottom";
                false ->
                    "center"
            end
    end.
