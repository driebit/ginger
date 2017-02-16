{% extends "beeldenzoeker/base.tpl" %}

{% block body_class %}t--adlib-object{% endblock %}

{% block content %}

{% with index|default:m.config.mod_ginger_adlib_elasticsearch.index.value as index %}
	{% with m.search[{elastic index=index filter=['priref', q.object_id] pagelen=1}]|first as result %}
        {% with result._source as record %}

            {% include "beeldenzoeker/masthead.tpl" record=record %}

            <main role="main">
                <div class="adlib-object__actions">
                    <div class="main-container">
                        {% include "beeldenzoeker/share.tpl" record=record %}
                        {% include "beeldenzoeker/download.tpl" record=record %}
                    </div>
                </div>
                <article class="main-content">
                    <h1 class="page-title">{{ record.title }}</h1>

                    {% block item_summary %}
                        {% if record.AHMteksten['AHM.texts.tekst'] %}

                            <p class="summary">
                                {{ record.AHMteksten['AHM.texts.tekst']|truncate:"100" }}
                            </p>
                        {% endif %}
                    {% endblock %}

                    <a href="http://amdata.adlibhosting.com/wwwopac.ashx/wwwopac.ashx?server=images&amp;command=getcontent&amp;value=S_A_11140_000.jpg&amp;width=1600&amp;height=1600" class="masthead__zoom">
                        <img src="http://amdata.adlibhosting.com/wwwopac.ashx/wwwopac.ashx?server=images&command=getcontent&value=S_A_11140_000.jpg&width=400&height=400">
                    </a>

                  {#   <a href="https://www.4en5meiamsterdam.nl/image/2017/2/14/stolpersteine.jpg%28%29%28E83BEE443B4C2C8DB3E66C67A336239C%29.jpg" class="masthead__zoom">
                        asdfasdfasdf
                    </a> #}
                    {% for reproduction in record.reproduction %}
                        {% include "beeldenzoeker/image.tpl" image=reproduction.value %}
                    {% endfor %}
                    {% print record %}
                </article>

                {# Part of collections #}
            </main>

        {% endwith %}
    {% endwith %}
{% endwith %}

{% endblock %}
