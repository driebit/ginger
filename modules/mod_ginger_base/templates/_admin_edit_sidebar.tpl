{% extends "admin_edit_widget_std.tpl" %}
{% block widget_title %}{_ Copyrights _}{% endblock %}
{% block widget_show_minimized %}true{% endblock %}
{% block widget_id %}sidebar-rights{% endblock %}

{% block widget_content %}
{% with m.rsc[id] as r %}
    <fieldset class="form-horizontal">
    <div id="thing-cc">
         <div>
            <input type="radio" name="rights" id="rights" value="BY,SA" {% if r.rights|upper=="BY,SA" %}checked{% endif %} />
                <span class="icon-cc cc-by-sa">{# sprite image here #}</span>
                <span class="caption">
                    {_ You must give the original author credit, this work must be licensed under an identical license if used _}
                </span>
        </div>
        <div>
            <input type="radio" name="rights" id="rights" value="BY,ND" {% if r.rights|upper=="BY,ND" %}checked{% endif %} />
                <span class="icon-cc cc-by-sa">{# sprite image here #}</span>
                <span class="caption">
                    {_ You must give the original author credit, you may not alter, transform, or build upon this work. _}
                </span>
        </div>
        <div>
            <input type="radio" name="rights" id="rights" value="BY" {% if r.rights|upper=="BY" %}checked{% endif %} />
                <span class="icon-cc cc-by-sa">{# sprite image here #}</span>
                <span class="caption">
                    {_ You must give the original author credit _}
                </span>
        </div>
        <div>
            <input type="radio" name="rights" id="rights" value="BY,NC,ND" {% if r.rights|upper=="BY,NC,ND" %}checked{% endif %} />
                <span class="icon-cc cc-by-sa">{# sprite image here #}</span>
                <span class="caption">
                    {_ You must give the original author credit, you may not use this work for commercial purposes, you may not alter, transform, or build upon this work _}
                </span>
        </div>
        <div>
            <input type="radio" name="rights" id="rights" value="BY,NC" {% if r.rights|upper=="BY,NC" %}checked{% endif %} />
                <span class="icon-cc cc-by-sa">{# sprite image here #}</span>
                <span class="caption">
                    {_ You must give the original author credit, you may not use this work for commercial purposes _}
                </span>
       </div>
        <div>
            <input type="radio" name="rights" id="rights" value="BY,NC,SA" {% if r.rights|upper=="BY,NC,SA" %}checked{% endif %} />
                <span class="icon-cc cc-by-sa">{# sprite image here #}</span>
                <span class="caption">
                    {_ You must give the original author credit, you may not use this work for commercial purposes, this work must be licensed under an identical license if used _}
                </span>
       </div>
        <div>
            <input type="radio" name="rights" id="rights" value="PD" {% if r.rights|upper=="PD" %}checked{% endif %} />
                <span class="icon-cc cc-by-sa">{# sprite image here #}</span>
                <span class="caption">
                    {_ You may use the work freely _}
                </span>
        </div>
        <div>
            <input type="radio" name="rights" id="rights" value="PD" {% if r.rights %} {% else %}checked{% endif %} />
                <span class="icon-cc cc-by-sa">{# sprite image here #}</span>
                <span class="caption">
                    {_ All rights reserved _}
                </span>
       </div>
       </fieldset>
   </div>
{% endwith %}
{% endblock %}


