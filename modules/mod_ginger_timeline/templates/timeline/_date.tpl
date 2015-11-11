{% if date %}
    "{{ name }}": {
        "year": "{{ date|date:"Y" }}",
        "month": "{{ date|date:"m" }}",
        "day": "{{ date|date:"d" }}"
    },
{% endif %}
