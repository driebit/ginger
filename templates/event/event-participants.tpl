
<div id="participants" class="participants">
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
</div>
