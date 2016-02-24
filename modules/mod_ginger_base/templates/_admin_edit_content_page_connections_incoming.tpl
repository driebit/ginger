{% extends "admin_edit_widget_std.tpl" %}

{# Widget for editing connections between rscs #}

{% block widget_title %}
  {_ Incoming connections _}
{% endblock %}

{% block widget_show_minimized %}true{% endblock %}
{% block widget_id %}sidebar-connections-incoming{% endblock %}

{% block widget_content %}

  {% with m.search.paged[{referrers id=id}] as result %}

    {% if result|length > 0 %}

      {% for connection, rank in result %}
        <a href="{% url admin_edit_rsc id=connection.id %}">{{ connection.title }}</a>
        <hr></hr>
      {% endfor %}

    {% else %}
        {_ This resource has no incoming connections. _}
        <hr></hr>
    {% endif %}

  {% endwith %}

{% endblock %}
