{% with id.o.depiction as deps %}
{% with id.o.hasdocument as docs %}
    {% if deps|length > 1 or docs %}
        <div class="article_images container-fluid">
        		{% if deps|length > 1 or docs %}
        			<div class="thumbnails row">
        				{% for dep in deps %}
                            {% if dep.id.medium.mime=="video/mp4" or dep.id.medium.mime=="video/webm" or dep.id.medium.mime=="video/ogg" or dep.id.medium.mime=="video/x-flv" or dep.id.medium.mime=="video/x-swv" or dep.id.is_a.image %}
                                {% if not forloop.first %}
                                    {% catinclude "_media_thumb.tpl" dep %}
                                {% endif %}
                            {% else %}
                                {% if not forloop.first %}
                                    {% catinclude "_media_thumb.tpl" dep %}
                                {% endif %}
                            {% endif %}
        				{% endfor %}
        				{% for doc in docs %}
                            {% catinclude "_media_thumb.tpl" doc %}
        				{% endfor %}
        			</div>
        		{% endif %}
        </div>
    {% endif %}
{% endwith %}
{% endwith %}
