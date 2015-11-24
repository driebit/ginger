<div class="infobox__results">{{ results|length }} {_ results(s) _}:</div>
<ul class="infobox">
    {% for id in results %}
        {% catinclude "map/map-infobox-item.tpl" id %}
    {% endfor %}
</ul>