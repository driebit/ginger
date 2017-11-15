{% with m.rsc[id] as rsc %}

<!DOCTYPE html>

<head>
    <title>{{ rsc.title }}</title>
    <link rel="stylesheet" type="text/css" href="{% url embed_css use_absolute_url z_language=false %}" />
</head>

<body>

    <main>
        <article class="ginger-embed">
            <a href="{{ rsc.uri }}" target="_blank" class="ginger-embed__from">{{ rsc.uri }} »</a>
            <header>
                {% if rsc.id.depiction %}
                    <figure>
                        {% image rsc.id.depiction mediaclass="embed" %}
                    </figure>
                {% endif %}
                <div>
                    <h1>{{ rsc.title }}</h1>
                    <h2>{{ rsc.alternative }}</h2>

                    <small>
                        <time>{{ rsc.id.publication_start|date:"d M Y" }}</time>
                        {{ m.rsc[rsc.creator_id].title }}
                    </small>
                </div>
            </header>

            <section>
                <p class="ginger-embed__intro">{{ rsc.summary }}</p>
                <p>{{ rsc.body|truncate:500 }}</p>
                <p><a href="{{ rsc.uri }}" target="_blank" class="ginger-embed__readmore">Lees verder</a></p>
            </section>
        </article>
    </main>

</body>

</html>



{% endwith %}
