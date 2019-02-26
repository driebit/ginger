{% with
    class|default:"audio"
as
 class
%}

<div class="{{ class }}">
    <audio controls>
        <source src="/media/attachment/{{ id.medium.filename }}" type="{{ id.medium.mime }}">
    </audio>

    {% if caption|default:m.rsc[id].summary|default:id.title as caption %}
        <div>
            {{ caption }}
        </div>
    {% endif %}
</div>

{% endwith %}
