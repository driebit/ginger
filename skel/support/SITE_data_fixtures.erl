-module(%%site_data_fixtures%%).
-author("Driebit <tech@driebit.nl>").

-export([
    load/1
]).

-include_lib("zotonic.hrl").

%% @doc Load data fixtures
load(Context0) ->
    % Ensure we are loading the resources outside a transaction, just like
    % the module manager is inserting resources after the manage_schema/2 call.
    Context = z_context:new(Context0),
    ginger_config:install_config(
        [
            % {site, config_key, "content"},
        ],
        Context
    ),

    schema:load(get_prod_data(Context), Context),

    case ginger_environment:is_prod(Context) of
        false ->
            schema:load(get_dev_data(Context), Context);
        true ->
            noop
    end,

    ok.

%% @doc This data is always loaded.
get_prod_data(Context) ->
    #datamodel{
        categories = [
            % {unique_name, under_category, [
            %     {title, {trans, [
            %         {nl, <<"title">>},
            %         {en, <<"title">>}
            %     ]}}
            % ]}
        ],
        predicates = [
            % {hasunique_name, [
            %         {title, <<"title">>}
            %     ], [
            %         {cat, cat}
            % ]}
        ],
        resources = [
            % {unique_name, category, [
            %     {title, <<"title">>}
            % ]}
        ],
        edges = [
            % {unique_name, predicate, unique_name}
        ],
        media = [
            % {unique_name, schema:file("folder/title.jpg", Context), [
            %     {title, <<"title">>}
            % ]}
        ],
        data = [
            {acl_rules, [
                % {module, [
                %     {acl_user_group_id, acl_user_group_unique_name},
                %     {actions, [use]},
                %     {module, module_name}
                % ]},
                % {rsc, [
                %     {acl_user_group_id, acl_user_group_unique_name},
                %     {actions, [view, insert, update, delete, link]},
                %     {category_id, category_unique_name}
                % ]},
            ]}
        ]
    }.

%% @doc This data is only loaded in dev environment
get_dev_data(Context) ->
    #datamodel{
        categories = [
            % {unique_name, under_category, [
            %     {title, {trans, [
            %         {nl, <<"title">>},
            %         {en, <<"title">>}
            %     ]}}
            % ]}
        ],
        resources = [
            % {unique_name, category, [
            %     {title, {trans, [
            %         {nl, <<"title">>},
            %         {en, <<"title">>}
            %     ]}}
            % ]}
        ],
        media = [
            % {unique_name, schema:file("folder/title.jpg", Context), [
            %     {title, <<"title">>}
            % ]}
        ],
        edges = [
            % {unique_name, predicate, unique_name}
        ],
        data = [
            % Can't have acl_rules here as it would replace the ACL rules from
            % the prod_data.
        ]
    }.

% install_menu(Context) ->
%     mod_menu:set_menu(
%         m_rsc:rid(main_menu, Context),
%         [
%             {unique_name, []},
%         ],
%         z_acl:sudo(Context)
%     ).

