-module(mod_ginger_edit).
-author("Driebit <info@driebit.nl>").

-mod_title("Ginger frontend edit module").
-mod_description("Provides Ginger frontend editing and adding dialogs").
-mod_prio(500).

-export([is_authorized/2
        ]).

is_authorized(ReqData, Context) ->
    z_acl:wm_is_authorized(use, z_context:get(acl_module, Context, mod_admin), admin_logon, ReqData, Context).

