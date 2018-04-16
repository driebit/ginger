{% with m.rsc[id] as rsc %}

<!DOCTYPE html>

<head>
    <title>{{ rsc.title }}</title>
    <link rel="stylesheet" type="text/css" href="{% url embed_css use_absolute_url z_language=false %}" />
</head>

<body>

    <main>
        <article class="ginger-embed">
            <a href="{% url page use_absolute_url id=rsc.id %}" target="_blank" class="ginger-embed__from">{{ m.config.title }} »</a>
            <header>
                {% if rsc.id.depiction %}
                    <figure>
                        {% image rsc.id.depiction mediaclass="embed" %}
                    </figure>
                {% endif %}
                <div>
                    <h1>{{ rsc.title|truncate:60 }}</h1>
                    {% if rsc.alternative %}<h2>{{ rsc.alternative }}</h2>{% endif %}

                    <small>
                        <time>{{ rsc.id.publication_start|date:"d M Y" }}</time>
                        {{ m.rsc[rsc.creator_id].title }}
                    </small>
                </div>
            </header>

            <section>

                <p>{{ rsc.id|summary:400 }}</p>

                <p><a href="{% url page use_absolute_url id=rsc.id %}" target="_blank" class="ginger-embed__readmore">Lees verder</a></p>
            </section>
        </article>
    </main>

</body>

</html>



{% endwith %}
