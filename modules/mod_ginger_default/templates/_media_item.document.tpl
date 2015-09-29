{% with m.rsc[id] as dep_rsc %}
    <a href="/image/{{ dep_rsc.medium.filename }}" target="_blank">
        <span class="btn btn-default button-edit"><span class="glyphicon glyphicon-download"></span></span><span> Download
        <figure>
            {% image dep_rsc.id mediaclass="img-content" class="img-responsive" alt="" %}
            <figcaption>
                {% if dep_rsc.title %}{{ dep_rsc.title }}{% endif %}
            </figcaption></span>
        </figure>
    </a>
{% endwith %}
