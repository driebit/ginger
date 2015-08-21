{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

  {% with
    href|default:id.page_url,
    image_class|default:"avatar__image",
    label
as
    href,
    image_class,
    label
%}

  <a href="{{ href }}" class="avatar" >
    {% if dep_rsc %}
        {% image dep_rsc.id mediaclass="avatar" class=image_class %}
    {% else %}
        <i class="icon-profile"></i>
    {% endif %}

    {% if label %}
        <span class="avatar__label">{{ label }}</span>
    {% endif %}

  </a>
  {% endwith %}

{% endblock %}

