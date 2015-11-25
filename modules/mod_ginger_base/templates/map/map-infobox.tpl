<div class="infobox__header">{{ results|length }} {_ results(s) _}:</div>
<ul class="infobox__results">
    {% for id in results %}
        {% catinclude "map/map-infobox-item.tpl" id %}
    {% endfor %}
</ul>
