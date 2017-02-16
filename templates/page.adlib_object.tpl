{% extends "beeldenzoeker/base.tpl" %}

{% block body_class %}t--home{% endblock %}

{% block content %}

{% with index|default:m.config.mod_ginger_adlib_elasticsearch.index.value as index %}
	{% with m.search[{elastic index=index filter=['priref', q.object_id]}]|first as result %}
        {% with result._source as record %}

    <main role="main" data-page-id="{{ id }}">
        <div class="home__header" style="background-image: url({% image_url banner.id width="1600" height="400" crop=banner.crop_center quality="80" %}); background-size: cover;">
            <div class="home__title">
                <h1>{% include "beeldenzoeker/title.tpl" title=record.title %}</h1>

                <p>{{ record.object_number }}</p>

                {% for reproduction in record.reproduction %}
                    {% include "beeldenzoeker/image.tpl" image=reproduction.value %}
                {% endfor %}

                {% print record %}

            </div>
        </div>
    </main>

        {% endwith %}
    {% endwith %}
{% endwith %}

{% endblock %}
