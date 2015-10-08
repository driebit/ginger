{% with id.o.depiction as deps %}
{% with id.o.hasdocument as docs %}

    {% if deps or docs %}

        <h3>ATTACHED MEDIA</h3>

        <div class="attached-media">

            {% if deps or docs %}
                <div class="">
                    {{ id | pprint }}
                    {% with deps|without_embedded_media:id|make_list++docs|without_embedded_media:id|make_list as list %}

                        <h1>media</h1>
                        {% for item in list %}
                            {% if item|is_not_a:"document" %}
                                {% catinclude "attached-media/attached-media-thumb.tpl" item %}
                            {% endif %}
                        {% endfor %}
                       
                        <h1>docs</h1>
                        {% for item in list %}
                            {% if item|is_a:"document" %}
                                {% catinclude "attached-media/attached-media-thumb.tpl" item %}
                            {% endif %}
                        {% endfor %}

                    {% endwith %}   

                </div>
            {% endif %}

        </div>

    {% endif %}
{% endwith %}
{% endwith %}
