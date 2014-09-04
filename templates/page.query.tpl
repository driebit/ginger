{% extends "page.tpl" %}

{% block page_class %}t-grid t-query{% endblock %}

{% block content %}
<div class="row">
    <div class="col-sm-12 col-md-12">
        <h2 class="page-title">{{ m.rsc[id].title }}</h2>
        {% with m.search.paged[{query query_id=id pagelen=24 page=q.page}] as result %}
            <p>
            {% pager id=id result=result %}
            {% include "_grid.tpl" items=result %}
        {% endwith %}
    </div>
</div>
{% endblock %}