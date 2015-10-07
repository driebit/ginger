{% with id.o.depiction as deps %}
{% with id.o.hasdocument as docs %}
    {% if deps or docs %}

        <h3>ATTACHED MEDIA</h3>

        <div class="attached-media">

                {% if deps or docs %}

                    <div class="">
                        {% if deps %} {% include "attached-media/loop-items.tpl" id=id items=deps %} {% endif %}
                        {% if docs %} {% include "attached-media/loop-items.tpl" id=id items=docs %} {% endif %}
                    </div>

                {% endif %}
        </div>

    {% endif %}
{% endwith %}
{% endwith %}
