<div class="adlib-object__meta">
	<div class="main-container">
        <div class="adlib-object__meta__row first">
	        <h6 class="adlib-object__meta__title">
	            {_ Identification _}
	        </h6>
	        <dl class="adlib-object__meta__data">
	        	<dt>{_ Title _}</dt>
	        	<dd>{% include "collection/title.tpl" title=record.title|default:record['dcterms:title'] %}</dd>

                {% if record['dcterms:identifier'] %}
	            	<dt>{_ Object nr. _}</dt>
	            	<dd>{{ record['dcterms:identifier'] }}</dd>
		        {% endif %}

                {% if record['handle'] as handle %}
	            	<dt>{_ Handle _}</dt>
	            	<dd><a href="http://hdl.handle.net/{{ handle }}">http://hdl.handle.net/{{ handle }}</a></dd>
		        {% endif %}

                {% if record.object_category as object_category %}
	            	<dt>{_ Object category _}</dt>
	            	<dd>{{ object_category }}</dd>
		        {% endif %}

	        	{% if record['rdf:type'] as types %}
	        		<dt>{_ Object type _}</dt>
	        		<dd>{% include "list/list-uri-labels.tpl" items=types %}</dd>
	        	{% endif %}

                {% if record['dbpedia-owl:isbn'] as isbn %}
		            <dt>{_ ISBN _}</dt>
		            <dd>{{ isbn }}</dd>
		        {% endif %}

                {% if record['dbpedia-owl:dutchPPNCode'] as ppn %}
		            <dt>{_ PPN _}</dt>
		            <dd>{{ ppn }}</dd>
		        {% endif %}

	            {% if record.collection %}
	            	<dt>{_ Collection _}</dt>
	            	<dd>{{ record.collection }}</dd>
	            {% endif %}
	        </dl>
	    </div>

        {% if record['dcterms:subject'] or record['foaf:depicts'] %}
            <div class="adlib-object__meta__row">
                <h6 class="adlib-object__meta__title">
                    {_ About _}
                </h6>
                <dl class="adlib-object__meta__data">
                {% if record['dcterms:subject'] as subjects %}
                    <dt>{_ Subjects _}</dt>
                    <dd>{% include "list/list-uri-labels.tpl" items=subjects %}</dd>
                {% endif %}

                {% if record['foaf:depicts'] as persons %}
                    <dt>{_ Persons _}</dt>
                    <dd>{% include "list/list-uri-labels.tpl" items=persons %}</dd>
                {% endif %}
                </dl>
            </div>
        {% endif %}

        {% if record['dcterms:language'] or record['dce:publisher']
            or record['schema:width'] or record['schema:height'] or ['foaf:document'] %}
            <div class="adlib-object__meta__row">
                <h6 class="adlib-object__meta__title">
                    {_ Work _}
                </h6>
                <dl class="adlib-object__meta__data">
                    {% include "collection/metadata/dimensions.tpl" %}

                    {% if record['dcterms:language'] %}
                        <dt>{_ Language _}</dt>
                        <dd>{{ record['dcterms:language']|join:", " }}</dd>
                    {% endif %}

                    {% if record['dbpedia-owl:genre'] as genre %}
                        <dt>{_ Genre _}</dt>
                        <dd>{{ genre|join:", " }}</dd>
                    {% endif %}

                    {% if record['dcterms:format'] as format %}
                        <dt>{_ Format _}</dt>
                        <dd>
                            {% if format|is_list %}
                                {{ format|join:", " }}
                            {% else %}
                                {{ format }}
                            {% endif %}
                        </dd>
                    {% endif %}

                    {% if record['dcterms:medium'] as medium %}
                        <dt>{_ Physical medium _}</dt>
                        <dd>{{ medium }}</dd>
                    {% endif %}

                    {% include "collection/metadata/bibliographic.tpl" %}

                    {% if record['dbpedia-owl:museum'] as museum %}
                        <dt>{_ Museum _}</dt>
                        <dd>
                            {% if museum['@id'] %}
                                {% include "collection/metadata/meta-link.tpl" href=museum['@id'] content=museum['rdfs:label']  %}
                            {% else %}
                                {{ museum['rdfs:label'] }}
                            {% endif %}
                        </dd>
                    {% endif %}

                    {% if record['dce:publisher'] as publisher %}
                        <dt>{_ Publisher _}</dt>
                        <dd>{{ publisher }}</dd>
                    {% endif %}

                    {% block documents %}
                        {% if record['foaf:document'] as documents %}
                            <dt>{_ Digital source _}</dt>
                            <dd>{% include "collection/documents.tpl" items=documents %}</dd>
                        {% endif %}
                    {% endblock %}
                </dl>
            </div>
        {% endif %}

        <div class="adlib-object__meta__row">
	        <h6 class="adlib-object__meta__title">
	            {_ Manufacture _}
	        </h6>
	        <dl class="adlib-object__meta__data">
                {% block creators %}
                    {% if record['dcterms:creator'] as creators %}
                        <dt>{_ Creator _}</dt>
                        <dd>
                            {% include "collection/metadata/creators.tpl" creators=creators %}
                        </dd>
                    {% endif %}
                {% endblock %}

                {% if record['dcterms:contributor'] as contributors %}
                    <dt>{_ Contributors _}</dt>
                    <dd>
                        {% include "collection/metadata/creators.tpl" creators=contributors %}
                    </dd>
                {% endif %}

                {% if record['dcterms:created'] or record['dcterms:date'] or record['dbo:productionStartYear']
                    or record['dbpedia-owl:constructionMaterial'] or record['dbpedia-owl:technique'] %}
                	<dt>{_ Dating _}</dt>
                	<dd>
                        {% include "collection/metadata/date.tpl" %}
                	</dd>
                {% endif %}

	            {% if record['production.place'] %}
	            	<dt>{_ Produced in _}</dt>
	            	<dd>{{ record['production.place'] }}</dd>
	            {% endif %}

                {% if record['dbpedia-owl:productionCompany'] as production_company %}
                    <dt>{_ Production company _}</dt>
                    <dd>{{ production_company }}</dd>
                {% endif %}

                {% if record['dbpedia-owl:constructionMaterial'] as materials %}
                    <dt>{_ Material _}</dt>
                    <dd>{% include "list/list-uri-labels.tpl" items=materials %}</dd>
                {% endif %}

                {% if record['dbpedia-owl:technique'] as techniques %}
                    <dt>{_ Technique _}</dt>
                    <dd>{% include "list/list-uri-labels.tpl" items=techniques %}</dd>
                {% endif %}
	        </dl>
	    </div>

        <div class="adlib-object__meta__row">
            <h6 class="adlib-object__meta__title">
                {_ Acquisition & License _}
            </h6>
            <dl class="adlib-object__meta__data">
            {% if record['acquisition.date'] %}
                <dt>{_ Acquired _}</dt>
                <dd>{% if record['acquisition.method'] %} {{ record['acquisition.method'] }} {{ record['acquisition.date']|isodate:"j F Y" }}{% endif %}</dd>
            {% endif %}

            <dt>{_ License _}</dt>
            <dd>
                {% if record['dcterms:license'] as license %}
                    {% include "collection/metadata/meta-link.tpl" href=m.creative_commons[license].language_url content=m.creative_commons[license].label  %}
                {% elseif record['copyright'] as license %}
                    {{ license }}
                {% else %}
                    {_ All rights reserved _}
                {% endif %}
            </dd>

            {% if record['credit_line'] %}
                <dt>{_ Credit line _}</dt>
                <dd>{{ record['credit_line'] }}</dd>
            {% endif %}
	        </dl>
	    </div>

        {% include "collection/metadata/geo.tpl" places=record['dcterms:spatial'] %}

        {% optional include "collection/metadata/reproduction.tpl" %}

	    {% if record.uri as uri %}
		    <div class="adlib-object__meta__row">
		        <h6 class="adlib-object__meta__title">
		            {_ Sustainable web address _}
		        </h6>
		        <div class="adlib-object__meta__data">
	                {_ If you want to refer this object then use this URL _}
	                <a href="{{ uri }}" target="_blank">{{ uri }} <i class="icon--external"></i></a>
		        </div>
		    </div>
		{% endif %}
        {% if m.acl.is_allowed.view.internal_adlib_content %}
            <div class="adlib-object__meta__row last">
                <h6 class="adlib-object__meta__title">
                    {_ Internal _}
                </h6>
                <dl class="adlib-object__meta__data">
                    {% optional include "collection/metadata/internal.tpl" %}
                    {% if record['@attributes']['modification'] as notes %}
                        <dt>{_ Last updated _}</dt>
                        <dd>{{ record['@attributes']['modification']|isodate:"j F Y H:i" }}</dd>
                    {% endif %}
                </dl>
            </div>
        {% endif %}
	</div>
</div>
