{% with m.comment.rsc[id]|length as number_of_comments %}
    <i class="icon--comments"></i><span id="test">
    {% if number_of_comments == 0 %}
        {_ No comments _}
    {% elseif number_of_comments == 1 %}
        {_ 1 comment _}
    {% else %}
        {{ number_of_comments }} {_ comments _}
    {% endif %}
    </span>
{% endwith %}
