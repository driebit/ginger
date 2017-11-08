{% with m.rsc[id] as rsc %}

<html>

<head>
    <title>{{ rsc.title }}</title>
    <link rel="stylesheet" type="text/css" href="{% url embed_css use_absolute_url z_language=false %}" />
</head>

<body>

    <main>
        <h4>{{ rsc.uri }} »</h4>
        <header>
            {% image rsc.id.depiction mediaclass="gigner-e" %}
            <div>
                <h1>{{ rsc.title }}</h1>
                <h2>{{ rsc.alternative }}</h1>
                    <time>{{ rsc.id.publication_start|date:"d-m-Y" }}</time>
                    <small>{{ m.rsc[rsc.creator_id].title }}</small>
            </div>
        </header>

        <section>
            <h3>{{ rsc.summary }}</h3>
            <p>{{ rsc.body|truncate:500 }}</p>
        </section>
    </main>

</body>

</html>



{% endwith %}
