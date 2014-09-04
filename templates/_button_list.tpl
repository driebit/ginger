{% if items %}
    {% if title %}
        <h4 class="section-title">{{ title }}</h4>
    {% endif %}

    <div class="btn-toolbar list-{{ class }}" role="toolbar">
      <div class="btn-group btn-group-xs">
        {% for id in items %}
            <a href="{{ id.page_url }}" class="btn btn-default">{{ id.title }}</a>
        {% endfor %}
      </div>
    </div>
{% endif %}