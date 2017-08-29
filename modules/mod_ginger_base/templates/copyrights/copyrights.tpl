{% if id.rights %}
    {% with m.creative_commons[id.rights].language_url as license_url %}
    <div class="copyrights">

        {% if id.rights|upper=="BY,SA" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_ You must give the original author credit, this work must be licensed under an identical license if used _}">
                <i class="icon--cc-by"></i><i class="icon--cc-sa"></i>
            </a>

        {% elif id.rights|upper=="BY,ND" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_ You must give the original author credit, you may not alter, transform, or build upon this work. _}">
                <i class="icon--cc-by"></i><i class="icon--cc-nd"></i>
            </a>

        {% elif id.rights|upper=="BY" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_You must give the original author credit _}">
                <i class="icon--cc-by"></i>
            </a>

        {% elif id.rights|upper=="BY,NC,ND" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_ You must give the original author credit, you may not use this work for commercial purposes, you may not alter, transform, or build upon this work _}">
                <i class="icon--cc-by"></i>
                <i class="icon--cc-nc"></i>
                <i class="icon--cc-nd"></i>
            </a>

        {% elif id.rights|upper=="BY,NC" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_ You must give the original author credit, you may not use this work for commercial purposes _}">
                <i class="icon--cc-by"></i><i class="icon--cc-nc"></i>
            </a>

        {% elif id.rights|upper=="BY,NC,SA" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_ You must give the original author credit, you may not use this work for commercial purposes, this work must be licensed under an identical license if used _}">
                <i class="icon--cc-by"></i>
                <i class="icon--cc-nc"></i>
                <i class="icon--cc-sa"></i>
            </a>

        {% elif id.rights|upper=="CC0" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_ You may use the work freely _}">
                <i class="icon--cc-cc0"></i>
            </a>

        {% elif id.rights|upper=="PD" %}
            <a href="{{ license_url }}" target="_blank" rel="nofollow" title="{_ You may use the work freely _}">
                <i class="icon--cc-pd"></i>
            </a>

        {% else %}
            <span class="caption">
                {_ All rights reserved _}
            </span>

       {% endif %}
    </div>
    {% endwith %}
{% endif %}
