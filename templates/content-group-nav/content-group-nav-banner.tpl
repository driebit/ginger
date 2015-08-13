{% if content_group.o.hasbanner %}
    {% with content_group.o.hasbanner.depiction as banner_dep %}
    <a href="#" class="content-group-nav__banner">
        <div class="content-group-nav__banner__bg" style="background-image: url('{% image_url banner_dep mediaclass='content-group-banner' %}');"></div> 
        <h1 class="content-group-nav__banner__title">{% if content_group.short_title %}{{ content_group.short_title }}{% else %}{{ content_group.title }}{% endif %}</h1>
    </a>
    {% endwith %}
{% endif %}