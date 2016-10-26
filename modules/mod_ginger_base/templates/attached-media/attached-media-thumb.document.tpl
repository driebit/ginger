<li>
    {% if id.medium.mime == "application/pdf" %}

        <a href="/image/{{ id.medium.filename }}" class="" target="_blank">
            <i class="icon--download"></i> {{ id.title }}
        </a>

    {% else %}

        <a href="/image/{{ id.medium.filename }}" rel="attached-media" >
            <i class="icon--download"></i> {{ id.title }}
        </a>

    {% endif %}
</li>
