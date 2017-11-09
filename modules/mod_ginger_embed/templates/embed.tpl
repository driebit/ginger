{% with m.rsc[id] as rsc %}

<!DOCTYPE html>

<head>
    <title>{{ rsc.title }}</title>
    <link rel="stylesheet" type="text/css" href="{% url embed_css use_absolute_url z_language=false %}" />
</head>

<body>

    <main>
        <a href="{{ rsc.uri }}" target="_blank"><h4>{{ rsc.uri }} »</h4></a>
        <header>
            <figure>
                {% image rsc.id.depiction mediaclass="embed" %}
            </figure>
            <div>
                <h1>{{ rsc.title }}</h1>
                <h2>{{ rsc.alternative }}</h1>

                <small>
                    <time>{{ rsc.id.publication_start|date:"d M Y" }}</time>
                    {{ m.rsc[rsc.creator_id].title }}
                </small>
            </div>
        </header>

        <section>
            <h3>{{ rsc.summary }}</h3>
            <p>{{ rsc.body|truncate:500 }}</p>
            <p><a href="{{ rsc.uri }}" target="_blank">Lees verder</a></p>
        </section>
    </main>

</body>

</html>



{% endwith %}
