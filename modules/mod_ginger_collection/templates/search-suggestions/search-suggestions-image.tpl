{% if url %}
    <div class="search-suggestions__suggestions__img" style="background-image: url({{ url }})"></div>
{% else %}
    <div class="search-suggestions__suggestions__img" style="background-image: url({% image_url id.o.depiction[1].id width="400" height="400" crop=id.o.depiction.id.crop_center %})"></div>
{% endif %}
