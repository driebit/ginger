/***
 * Ginger session handling. 
 * Support for one-page apps with user log-ins.
 */

function GingerSession ()
{
    pubzub.subscribe("~pagesession/session", this.sessionChange);
}

GingerSession.prototype.sessionChange = function(_topic, msg, _id) {
    if (msg.user_id && !msg.prev_user_id) {
        // If #dialog-connect-panels or #logon_methods displayed, then trigger logon-actions event
        // Else postback user-logon-event to update parts of screen
        if ($('#dialog-connect-panels,#logon_methods').length > 0) {
            z_event("ginger_logon_actions");
            z_dialog_close();
        } else {
            z_transport("ginger_logon", "ubf", { msg: "ginger_logon_actions" });
        }
    } else if (msg.user_id != msg.prev_user_id) {
        z_reload();
    }
};

(function($) {
    window.gingerSession = new GingerSession();
})(jQuery);
