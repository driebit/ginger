<div class="col-sm-3 col-xs-6">
    {% if id.medium.mime == "text/html-oembed" %}
        <a href="{{ id.medium.oembed.provider_url }}{{id.medium.oembed.video_id}}" class="lightbox lightbox-video-embed" rel="fancybox-group">
            {% image id mediaclass="thumbnail" title=id.title alt=id.title %}
        </a>    
    {% else %}
        <a href="{{ id.page_url }}" class="lightbox">
            {% image id mediaclass="thumbnail" title=id.title alt=id.title %}
        </a>    
    {% endif %}
	
</div>