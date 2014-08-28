{% extends "page.tpl" %}

{% block page_class %}t-search t-grid{% endblock %}

{% block content %}
	{% if q.qs %}

		{% with m.search[{query	text=q.qs}] as results %}

			<main class="query">
		        {% block body %}

					<h2 class="page-title">
						{_ Search results for _}
						<span class="keyword">{{ q.qs|escape }}</span>
					</h2>

					{% if results.total > 0 %}

						<div class="search-results">

							{% with m.search[{query	text=q.qs filter=['pivot_geocode', `gt`, 0]}] as geo_results %}

								{% if geo_results.total > 0 %}

									<a href="#map-results" class="btn btn-primary btn-show-map">Bekijk op de kaart</a>
									<div id="map-results" class="search-results_map">
										{% include "_map.tpl" items=results container="map-canvas" height=350 %}
									</div>

								{% endif %}

							{% endwith %}
							
							<div class="search-results_grid">
								{% include "_grid.tpl" items=results %}
							</div>
						</div>
					{% else %}
						<p>{_ Nothing found _}</p>
					{% endif %}
	
				{% endblock %}
			</main>

		{% endwith %}

	{% endif %}
{% endblock %}