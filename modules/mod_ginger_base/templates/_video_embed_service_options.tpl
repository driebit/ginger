{% overrules %}

{% block options %}
    <option value="ginger" {% ifequal service "ginger" %}selected="selected" {% endifequal %}>{_ Ginger Embed _}</option>
    {% inherit %}
{% endblock %}
