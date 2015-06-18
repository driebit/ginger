<form class="{% block mod_ginger_search_form_classes %}navbar-form navbar-right searchform{% endblock %}" id="search-form" role="search" action="{% if context %}/{{ context }}_search{% else %}{% url search %}{% endif %}" method="get">
    <div class="form-group">
        <input type="hidden" name="qsort" value="{{ q.qsort|escape }}" />
        <input type="hidden" name="qcat" value="{{ q.qcat|escape }}" />
        <input type="text" class="form-control do_suggestions" name="qs" value="{{q.qs|escape}}" placeholder="Search" autocomplete="off">
    </div>
    <button type="submit" class="btn btn-default " title="zoek"><span class="glyphicon glyphicon-search"></span></button>
    {% wire name="show_suggestions"
        action={update target="search-suggestions" template="_search_suggestions.tpl" context=context}
    %}
    <div id="search-suggestions">--</div>
</form>
