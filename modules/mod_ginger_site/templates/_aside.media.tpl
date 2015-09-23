<aside class="main-aside">

    {% with m.rsc[id] as r %}

        {% with r.subject as keywords %} 
            {% if keywords %}
               {% include "_button_list.tpl" title="Keywords" class="keywords" items=r.subject %}
            {% endif %}
        {% endwith %}

        {% include "_content_list.tpl" list=r.s.about title='About:'%}
        {% include "_content_list.tpl" list=id.s.depiction  title='On page:'%}
        {% include "_content_list.tpl" list=id.s.hasdocument %}


    {% endwith %}

</aside>
