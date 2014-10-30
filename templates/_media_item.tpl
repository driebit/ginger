<div class="video-wrapper">
    {% if dep.id.medium.mime=="video/mp4" or dep.id.medium.mime=="video/webm" or dep.id.medium.mime=="video/ogg" %}

        <video width="640" height="480" controls>
          <source src="/media/attachment/{{ dep.id.medium.filename }}" type="{{ dep.id.medium.mime }}">
        </video>

    {% elseif dep.id.medium.mime=="video/x-flv"%}

        {% lib "js/vendor/flowplayer-3.2.12.min.js" %}
        <a href="/media/attachment/{{ dep.id.medium.filename }}"
             style="display:block;width:560px;height:420px"  
             id="player"> 
        </a> 

        <script>
            flowplayer("player", "/lib/js/vendor/flowplayer-3.2.16.swf");
        </script>

    {% elseif dep.id.medium.mime=="video/x-swv"%}

        <video width="640" height="480" controls>
        <object data="/media/attachment/{{ dep.id.medium.filename }}" width="640" height="480">
            <embed src="/media/attachment/{{ dep.id.medium.filename }}" width="640" height="480">
        </object>
        </video>

    {% else %}
        {% media dep %}
    {% endif %}
</div>
