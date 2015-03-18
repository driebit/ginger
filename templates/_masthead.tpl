{% with article.header as header %}
    {% if header %}
        <div class="page__masthead" style="background-image: url({% image_url header.id mediaclass='img-header' crop %}); background-size: cover;">
    {% else %}
        <div class="page__masthead">
    {% endif %}
        </div>
{% endwith %}
