<a class="lightbox" rel="attached-media" href="#audio-{{ id.id}} ">
     {% image id mediaclass="attached-media" title=id.title alt=id.title %}
</a>

<div id="audio-{{ id.id}}" style="display: none">
    <h3>{{ id.title }}</h3>
    <audio controls>
        <source src="/media/attachment/{{ id.medium.filename }}" type="{{ id.medium.mime }}">
    </audio>
</div>