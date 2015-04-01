{% with article.header as header %}
    <div class="page__masthead"

    {% if article.header %}
        style="background-image: url({% image_url article.header.id mediaclass='img-header' crop %}); background-size: cover;"
    {% elseif article.media|length > 0 %}
        style="background-image: url({% image_url article.media|first mediaclass='img-header' crop %}); background-size: cover;"
    {% endif %}
        ></div>
{% endwith %}
