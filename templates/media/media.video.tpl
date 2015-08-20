{% if id.medium.mime=="video/mp4" or id.medium.mime=="video/webm" or id.medium.mime=="video/ogg" %}
    <div class="media--video video-wrapper">
        <video width="640" height="480" controls>
          <source src="/media/attachment/{{ id.medium.filename }}" type="{{ id.medium.mime }}">
        </video>
    </div>
{% elseif id.medium.mime=="video/x-flv"%}
    <div class="media--video video-wrapper">
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
    <div class="media--video video-wrapper">
        <video width="640" height="480" controls>
        <object data="/media/attachment/{{ id.medium.filename }}" width="640" height="480">
            <embed src="/media/attachment/{{ id.medium.filename }}" width="640" height="480">
        </object>
        </video>
    </div>
{% else %}
    {% media id %}
{% endif %}
