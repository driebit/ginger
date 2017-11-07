{% with m.rsc[q.id|to_integer] as rsc %}

    <style>
        main {
            padding: 2rem;
            display: block;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            line-height: 160%;
            border: 1px solid red;
        }

        h1, h2, h3, h4 {
            margin: 0;
            padding: 0;
            line-height: 130%;
        }

        h1 {
            font-size: 3rem;
            font-weight: 500;
        }

        h2 {
            font-size: 2rem;
            font-weight: 500;
        }

        h3 {
            font-size: 1.5rem;
            font-weight: 400;
            text-transform: uppercase;
        }

        h4 {
            font-size: 1.5rem;
            font-weight: 500;
            text-transform: uppercase;
            background-color: red;
            padding: 1rem;
        }

        header {
            display: flex;
            margin: 2rem 0;
        }

        img {
            width: 100px;
            height: auto;
            margin-right: 2rem;
        }

        p {
            margin: 1rem 0;
        }
    </style>

    <main>
        <h4>{{ rsc.uri }} »</h4>
        <header>
            <div>
                <h1>{{ rsc.title }}</h1>
                <h2>{{ rsc.alternative }}</h1>
                <small>{{ rsc[rsc.creator_id].title }}</small>
            </div>
        </header>
        <section>
            <h3>{{ rsc.summary }}</h3>
            <p>{{ rsc.body|truncate:1000 }}</p>
        </section>
    </main>

{% endwith %}
