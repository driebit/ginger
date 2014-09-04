{% block search %}
    <div class="navbar-right">
    <form class="navbar-right navbar-form form-inline hidden-sm" action="{% url search %}#content-pager" method="get">
        <input type="hidden" name="qsort" value="{{ q.qsort|escape }}" />
        <input type="hidden" name="qcat" value="{{ q.qcat|escape }}" />
        <input class="search-query col-md-6 form-control" type="text" name="qs" value="{{q.qs|escape}}" placeholder="Search..." />
    </form>
    </div>
{% endblock %}
