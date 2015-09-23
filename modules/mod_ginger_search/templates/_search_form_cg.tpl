{% with id.content_group_id as cg_id %}
{% with m.rsc[cg_id].title as cg_title %}
{% with m.rsc[cg_id].name as cg_name %}

 <form class="ginger-search {{ extraClasses }}" id="ginger-search-form-{{ identifier }}" role="search" action="{% if context %}/{{ context }}_search{% else %}{% url search %}{% endif %}" method="get">
    <div class="ginger-search_form-group">
        <input type="hidden" name="qsort" value="{{ q.qsort|escape }}" />
        <input type="hidden" name="qcat" value="{{ q.qcat|escape }}" />
        <input type="hidden" name="qcg" value="{{ cg_name }}" />
        <input type="text" 
            class="ginger-search_form-control do_ginger_search"
            name="qs" 
            value="{{q.qs|escape}}" 
            placeholder="{_ Search in _} {{ cg_title }}"
            autocomplete="off"
            data-param-wire="show-suggestions-{{ identifier }}" 
            data-param-results="ginger-search-suggestions-{{ identifier }}" 
            data-param-container="ginger-search-form-{{ identifier }}"  />
    </div>
    <button type="submit" class="ginger-search_submit-btn" title="zoek"><span class="z-icon z-icon-search"></span></button>
    {% wire name="show-suggestions-"++identifier
        action={update target="ginger-search-suggestions-"++identifier template="_search_suggestions.tpl" context=context cg_name=cg_name}
    %}
    <div class="ginger-search_suggestions" id="ginger-search-suggestions-{{ identifier }}">--</div>
</form>

{% endwith %}
{% endwith %}
{% endwith %}