{% if url %}
    <div class="list__item__image"><img src="{{ url }}"></div>
{% else %}
    {% if item._type|member:["books"|to_binary,"articles"|to_binary,"serials"|to_binary,"dublincore"|to_binary,"resource"|to_binary] %}
        <div class="list__item__image no-image no-image-book"></div>
    {% else %}
        <div class="list__item__image no-image"></div>
    {% endif %}
{% endif %}
