{% with id.o.depiction as deps %}
{% with id.o.hasdocument as docs %}

    {% if deps or docs %}

        <div class="attached-media">

            <h2 class="attached-media__title">{_ Media gallery _}</h2>

            {% if deps or docs %}
                {% with deps|without_embedded_media:id|make_list++docs|without_embedded_media:id|make_list as list %}
                    <div class="attached-media__media">
                        <h3 class="attached-media__subtitle">{_ Media _}</h3>

                        {% for item in list %}
                            {% if item|is_not_a:"document" %}
                                {% catinclude "attached-media/attached-media-thumb.tpl" item %}
                            {% endif %}
                        {% endfor %}
                    </div>

                    <div class="attached-media__documents">
                        <h3 class="attached-media__subtitle">{_ Documents _}</h3>

                        <ul>
                            {% for item in list %}
                                {% if item|is_a:"document" %}
                                    {% catinclude "attached-media/attached-media-thumb.tpl" item %}
                                {% endif %}
                            {% endfor %}
                        </ul>
                    </div>

                {% endwith %}
            {% endif %}

        </div>

    {% endif %}
{% endwith %}
{% endwith %}
