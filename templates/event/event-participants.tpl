
<div id="participants" class="meta-participants">
    <h4 class="meta-participants__header"><i class="icon--person"></i>{_ Deelnemers _}</h4>
    {% with
        limit|default:9999,
        id.s.participant
    as
        limit,
        participant
    %}
        <div class="meta-participants__content">
            {% for p in participant|slice:[,limit] %}
                <a href="{{ p.page_url }}">{{ p.title }}</a>{% if not forloop.last %}, {% endif %}
            {% endfor %}
        </div>
    {% endwith %}
</div>
