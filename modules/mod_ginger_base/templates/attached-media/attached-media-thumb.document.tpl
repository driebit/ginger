<li>
    {% if id.medium.mime == "application/pdf" %}

        <a href="#lightbox-{{ id }}" class="lightbox" rel="attached-media">
            <i class="icon--download"></i> {{ id.title }}
        </a>

        <div class="lightbox-pdf-wrapper">
            <div id="lightbox-{{ id }}" class="lightbox-pdf">
                <embed width="800" height="550" src="/image/{{ id.medium.filename }}" type="application/pdf"></embed>
            </div>
        </div>

    {% else %}

        <a href="/image/{{ id.medium.filename }}" rel="attached-media" >
            <i class="icon--download"></i> {{ id.title }}
        </a>

    {% endif %}


</li>
