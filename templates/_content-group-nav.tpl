{% with m.rsc[id.content_group_id] as content_group %}
        {% if content_group and content_group.name != "system_content_group" and content_group.name != "default_content_group" %}
                {% if content_group.o.hasbanner %}
                    {% with content_group.o.hasbanner.depiction as banner_dep %}               

                        <a href="#" class="content-groups-nav__banner" style="background-image: url('{% image_url banner_dep mediaclass='img-banner' %}');">
                            <h1 class="content-groups-nav__banner__title">{{ content_group.title }} </h1>
                        </a>

                    {% endwith %}
                {% endif %}
        {% endif %}
    {% endwith %}









