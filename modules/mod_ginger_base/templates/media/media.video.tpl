{% with class|default:"media--video video-wrapper" as class %}
    {% if id.medium.mime=="video/mp4" or id.medium.mime=="video/webm" or id.medium.mime=="video/ogg" %}
        <div class="{{ class }}">
            <video width="600" height="400" controls>
              <source src="/media/attachment/{{ id.medium.filename }}" type="{{ id.medium.mime }}">
            </video>
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
