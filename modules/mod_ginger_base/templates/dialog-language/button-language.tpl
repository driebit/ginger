{% with m.translation.language_list_enabled as languages %}
    
    {% block button %}

        {% if languages|length > 1 %}

            <a id="{{ #language }}" href="#" class="language--global-nav {{ extraClasses }}">
                <i class="icon--flag"></i> {{ z_language }}
            </a>
            
            {% wire
                id=#language
                action={
                    dialog_open
                    title=_"Choose language"
                    raw_path=raw_path
                    template="dialog-language/dialog-language.tpl"
                }
            %}

        {% endif %}

    {% endblock %}

{% endwith %}


