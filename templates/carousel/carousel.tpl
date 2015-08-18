{% if items %}

    {% block carousel %}
        <ul id="{{ carousel_id }}" class="carousel {{ extraClasses }}">
            {% for id in items %}
                {% if itemtemplate %}
                    {% include itemtemplate id=id %}
                {% else %}
                    {% catinclude "carousel/carousel-item.tpl" id %}
                {% endif %}
            {% endfor %}
        </ul>
    {% endblock %}

    {% block pager %}
       <!--  <ul id="{{ pager }}" class="carousel-pager">
            {% for id in items %}
                {% with id.depiction as dep %}

                    {% if pagertemplate %}
                        {% include pagertemplate id=id counter=forloop.counter0 %}
                    {% else %}
                        <li class="carousel-pager_item">
                            <a data-slide-index="{{ forloop.counter0 }}" href=""> 
                                {% if m.media[id].preview_filename %}
                                    {% image m.media[id].preview_filename mediaclass="pager-image" alt=id.title %}
                                {% else %}
                                    {% image id.depiction mediaclass="pager-image" alt=id.title %}
                                {% endif %}
                            </a>
                        </li>
                    {% endif %}

                {% endwith %}
            {% endfor %}
        </ul> -->
    {% endblock %}

    {% javascript %}
        $('#{{ carousel_id }}').slick({{ config }});
    {% endjavascript %}

{% endif %}