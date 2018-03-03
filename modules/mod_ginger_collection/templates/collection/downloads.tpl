{# Show list of downloads for this record #}

{% with
    record['foaf:depiction']|default:[],
    width,
    height,
    template
as
    downloads,
    width,
    height,
    template
%}
    {% if downloads|object_is_visible as downloads %}
        <div class="adlib-download">
            {% if downloads|length == 1 %}
                {% include "collection/asset.tpl" asset=downloads|first template="collection/download-button.tpl" %}
            {% else %}
                <button class="adlib-action__btn">{_ Downloads _}</button>
                <div class="adlib-download__list__wrapper">
                    <ul>
                        {% for download in downloads %}
                            <li>{% include "collection/asset.tpl" asset=download template="collection/download-link.tpl" %}</li>
                        {% endfor %}
                    </ul>
                    <div class="adlib-download__list__chevron"></div>
                </div>
                
            {% endif %}
        </div>
    {% endif %}
{% endwith %}
