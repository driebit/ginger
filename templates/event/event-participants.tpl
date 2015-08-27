<h2>PARTICIPANTS</h2>

{% with 
    limit|default:9999,
    id.s.participant
as
    limit,
    participant
%}

    {% for p in participant|slice:[,limit] %}
        {{ p.title }}, 
    {% endfor %}

{% endwith %}