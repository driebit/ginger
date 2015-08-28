
{% block button %}
    <a id="{{ #language }}" href="#" class="language--global-nav {{ extraClasses }}">
        <i class="icon--language"></i> {{ z_language }}
    </a>
{% endblock %}

{% wire
    id=#language
    action={
        dialog_open
        title=_"Taalkeuze"
        template="dialog-language/dialog-language.tpl"
    }
%}