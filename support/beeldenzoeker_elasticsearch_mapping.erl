-module(beeldenzoeker_elasticsearch_mapping).

-export([
    default_mapping/0
]).

%% @doc Default mappings are based on linked data predicates.
default_mapping() ->
    #{<<"properties">> => #{
        <<"dcterms:created">> => #{
            <<"type">> => <<"date">>
        },
        <<"dcterms:date">> => #{
            <<"type">> => <<"date">>
        },
        <<"dbo:creationYear">> => #{
            <<"type">> => <<"date">>
        },
        <<"dbo:productionStartYear">> => #{
            <<"type">> => <<"date">>
        },
        <<"dbo:productionEndDate">> => #{
            <<"type">> => <<"date">>
        },
        <<"dbo:productionEndYear">> => #{
            <<"type">> => <<"date">>
        }
    }}.
