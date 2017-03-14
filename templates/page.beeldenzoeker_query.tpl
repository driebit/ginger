{% extends "beeldenzoeker/base.tpl" %}

{% block body_class %}do_mod_am_default query{% endblock %}
{% block container_class %}container container-topmargin %}{% endblock %}

{% block content %}

	{% include "_collection_header.tpl" id=id %}

	{% block page_content %}

		{% with m.search[{beeldenzoeker query_id=id index=m.config.mod_ginger_adlib_elasticsearch.index.value}] as result %}

            {% include "list/list-beeldenzoeker.tpl" items=result id=id hide_showall_button hide_showmore_button dispatch_pager="beeldenzoeker" list_template="list/list-item-beeldenzoeker.tpl" %}

		{% endwith %}
	{% endblock %}
{% endblock %}
