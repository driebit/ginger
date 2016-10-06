{% with
    class|default:"audio"
as
 class
%}

<div class="{{ class }}">

    <audio controls>
        <source src="/media/attachment/{{ id.medium.filename }}" type="{{ id.medium.mime }}">
    </audio>

    <div>
        {% if id.summary %}
            {{ id.summary }}
        {% elif id.title %}
            {{ id.title }}
        {% endif %}
    </div>

</div>

{% endwith %}
