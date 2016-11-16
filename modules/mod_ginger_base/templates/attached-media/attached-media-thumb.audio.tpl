<a class="lightbox" rel="body" href="#audio-{{ id.id}}" {% if id.summary %}title="{{ id.summary }}"{% endif %}>
     {% image id mediaclass="media-thumb" title=id.title alt=id.title %}
</a>

<div id="audio-{{ id.id}}" style="display: none">
    <h3>{{ id.title }}</h3>
    <audio controls>
        <source src="/media/attachment/{{ id.medium.filename }}" type="{{ id.medium.mime }}">
    </audio>
</div>
