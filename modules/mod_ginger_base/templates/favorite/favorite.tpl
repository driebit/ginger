{% with
    btn_connect_text|default:_"Like",
    btn_cancel_text|default:_"Unlike",
    predicate|default:"interest"

as
    btn_connect_text,
    btn_cancel_text,
    predicate
%}

    {% include "page-actions/page-action-connect-user.tpl"
        id=id
        predicate=predicate
        btn_connect_text=btn_connect_text
        btn_cancel_text=btn_cancel_text
    %}

{% endwith %}
