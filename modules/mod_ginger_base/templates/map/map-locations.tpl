{% for rid, lat, lng, cat in result %}
    {
        "lat": "{{ lat }}",
        "lng": "{{ lng }}",
        "id": "{{ rid }}",
        "icon": "{{ cat.o.hasicon[1].medium.filename }}"
    }
    {% if not forloop.last %},{% endif %}
{% endfor %}