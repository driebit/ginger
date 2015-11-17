<div class="infobox__results">{{ results|length }} {_ results(s) _}:</div>
<ul class="infobox">
    {% for id in results %}
        {% catinclude "list/list-item-map.tpl" id %}
    {% endfor %}
</ul>