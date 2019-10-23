{% with
    caption|default:m.rsc[id].summary,
    (sizename == "middle")|if:"medium":sizename
as
    caption,
    sizename
%}
<figure class="align-{{ align }} -{{ sizename }}">
    <div class="video-figure__container">
        {% with class|default:"media--video video-wrapper" as class %}
            {% if id.medium.mime=="video/mp4" or id.medium.mime=="video/webm" or id.medium.mime=="video/ogg" %}
                <div class="{{ class }}">
                    {% with id.o.depiction as dep %}
                        <video width="600" height="400" muted {% if dep %}poster="{% image_url dep.id mediaclass='landscape-large' %}"{% endif %} controls>
                          <source src="/media/attachment/{{ id.medium.filename }}" type="{{ id.medium.mime }}">
                        </video>
                    {% endwith %}
                </div>
            {% elseif id.medium.mime=="video/x-flv"%}
                <div class="{{ class }}">
                    {% lib "js/vendor/flowplayer-3.2.12.min.js" %}
                    <a href="/media/attachment/{{ id.medium.filename }}"
                         style="display:block;width:560px;height:420px"
                         id="player">
                    </a>
                    <script>
                        flowplayer("player", "/lib/js/vendor/flowplayer-3.2.16.swf");
                    </script>
                </div>
            {% elseif id.medium.mime=="video/x-swv"%}
                <div class="{{ class }}">
                    <video width="600" height="400" controls>
                    <object data="/media/attachment/{{ id.medium.filename }}" width="600" height="400">
                        <embed src="/media/attachment/{{ id.medium.filename }}" width="600" height="400">
                    </object>
                    </video>
                </div>
            {% else %}
                {% media id %}
            {% endif %}
        {% endwith %}
    </div>

    {% block figcaption %}
        {% include "media/_caption.tpl" caption=caption %}
    {% endblock %}
</figure>
{% endwith %}
