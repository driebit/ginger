{% with
    small_header|default:"true",
    hide_cover|default:"false",
    show_facepile|default:"true",
    show_posts|default:"true",
    width|default:"500",
    height
as
    small_header,
    hide_cover,
    show_facepile,
    show_posts,
    width,
    height
 %}

    {% if id.facebookpage %}
        <div id="facebook" class="fb-page" data-href="{{ id.facebookpage }}" data-width="{{ width }}" data-height="{{ height }}" data-small-header="{{ small_header }}" data-adapt-container-width="true" data-hide-cover="{{ hide_cover }}" data-show-facepile="{{ show_facepile }}" data-show-posts="{{ show_posts }}"></div>
    {% endif %}

{% endwith %}
