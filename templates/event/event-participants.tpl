<h2>PARTICIPANTS</h2>

{% with 
    limit|default:9999,
    id.o.participates
as
    limit,
    participants
%}

    {% for p in participants|slice:[,limit] %}
        {{ p.title }}, 
    {% endfor %}

{% endwith %}

