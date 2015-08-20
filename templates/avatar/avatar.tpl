{% with
    user,
    href|default:user.page_url,
    image_class|default:"avatar__image",
    label
as
    user,
    href,
    image_class,
    label
%}

<a href="{{ href }}" class="avatar" >
  {% if user.depiction %}
      {% image user.depiction mediaclass="avatar" class=image_class %}
  {% else %}
      <i class="icon-profile"></i>
  {% endif %}

  {% if label %}
      <span class="avatar__label">{{ label }}</span>
  {% endif %}

</a>

{% endwith %}