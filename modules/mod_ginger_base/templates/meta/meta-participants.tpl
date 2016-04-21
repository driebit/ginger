
{% with
    limit|default:999,
    id.s.participant|default:id.s.rsvp,
    id.rsvp_max_participants
as
    limit,
    participants,
    max_participants
%}
{% if participants %}
    <div id="participants" class="meta-participants">
        <h4 class="meta-participants__header"><i class="icon--person"></i>{_ Participants _}</h4>
            <div class="meta-participants__content">
                {% for p in participants|slice:[,limit] %}
                    <a href="{{ p.page_url }}">{{ p.title }}</a>{% if not forloop.last %}, {% endif %}
                {% endfor %}
                ({{ participants|make_list|length }}{% if max_participants %}/{{ max_participants }}{% endif %})
            </div>
    </div>
{% endif %}

{% endwith %}
