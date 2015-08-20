{% with
    items,
    carousel_id,
    extraClasses,
    config,
    carousel_id
as
    items,
    carousel_id,
    extraClasses,
    config,
    carousel_id
%}

{% if items %}

    {% block carousel %}
        <ul id="{{ carousel_id }}" class="carousel {{ extraClasses }}">
            {% for id in items %}
                {% catinclude itemtemplate id %}
            {% endfor %}
        </ul>
    {% endblock %}

    {% block pager %}
       <ul id="{{ pager }}" class="carousel__pager">
            {% for id in items %}
                {% catinclude pagertemplate id carousel_id=carousel_id counter=forloop.counter0 %}
            {% endfor %}
        </ul>
    {% endblock %}

    {% block javascript %}
        {% javascript %}
            $('#{{ carousel_id }}').carousel({{ config }});
        {% endjavascript %}
    {% endblock %}


{% endif %}

{% endwith %}