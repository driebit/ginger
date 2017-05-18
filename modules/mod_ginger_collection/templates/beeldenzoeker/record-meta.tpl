<div class="adlib-object__meta">
	<div class="main-container">
        <div class="adlib-object__meta__row first">
	        <div class="adlib-object__meta__title">
	            {_ Identification _}
	        </div>
	        <dl class="adlib-object__meta__data">
	        	<dt>{_ Title _}</dt>
	        	<dd>{% include "beeldenzoeker/title.tpl" title=record.title|default:record['dcterms:title'] %}</dd>

                {% if record['dcterms:identifier'] %}
	            	<dt>{_ Object nr. _}</dt>
	            	<dd>{{ record['dcterms:identifier'] }}</dd>
		        {% endif %}

                {% if record.object_category as object_category %}
	            	<dt>{_ Object category _}</dt>
	            	<dd>{{ object_category }}</dd>
		        {% endif %}

	        	{% if record['rdf:type'] as types %}
	        		<dt>{_ Object type _}</dt>
	        		<dd>{% include "list/list-uri-labels.tpl" items=types %}</dd>
	        	{% endif %}

                {% if record['dcterms:subject'] as subjects %}
                    <dt>{_ Subjects _}</dt>
                    <dd>{% include "list/list-uri-labels.tpl" items=subjects %}</dd>
                {% endif %}

                {% if record['dbpedia-owl:isbn'] as isbn %}
		            <dt>{_ ISBN _}</dt>
		            <dd>{{ isbn }}</dd>
		        {% endif %}

	            {% if record.collection %}
	            	<dt>{_ Collection _}</dt>
	            	<dd>{{ record.collection }}</dd>
	            {% endif %}

                <dt>{_ Last updated _}</dt>
                <dd>{{ record['@attributes']['modification']|isodate:"j F Y H:i" }}</dd>
	        </dl>
	    </div>
        {% if record['dcterms:language'] or record['dbpedia-owl:museum'] or record['dce:publisher']
            or record['schema:width'] or record['schema:height'] or ['foaf:document'] %}
            <div class="adlib-object__meta__row">
                <div class="adlib-object__meta__title">
                    {_ Work _}
                </div>
                <dl class="adlib-object__meta__data">
                    {% include "beeldenzoeker/metadata/dimensions.tpl" %}

                    {% if record['dcterms:language'] as language %}
                        <dt>{_ Language _}</dt>
                        <dd>{{ record['dcterms:language'] }}</dd>
                    {% endif %}

                    {% if record['dbpedia-owl:museum'] as museum %}
                        <dt>{_ Museum _}</dt>
                        <dd>
                            {% if museum['@id'] %}
                                <a href="{{ museum['@id'] }}">{{ museum['rdfs:label'] }}</a>
                            {% else %}
                                {{ museum['rdfs:label'] }}
                            {% endif %}
                        </dd>
                    {% endif %}

                    {% if record['dce:publisher'] as publisher %}
                        <dt>{_ Publisher _}</dt>
                        <dd>{{ publisher }}</dd>
                    {% endif %}

                    {% if record['foaf:document'] as documents %}
                        <dt>{_ Documents _}</dt>
                        <dd>{% include "list/list-uri-labels.tpl" items=documents %}</dd>
                    {% endif %}

                </dl>
            </div>
        {% endif %}

        <div class="adlib-object__meta__row">
	        <div class="adlib-object__meta__title">
	            {_ Manufacture _}
	        </div>
	        <dl class="adlib-object__meta__data">
                {% if record['dcterms:creator'] as creators %}
                    <dt>{_ Creator _}</dt>
                    <dd>
                        <ol>
                            {% for creator in creators %}
                                <li>
                                    {% if creator['@id'] %}<a href="{{ creator['@id'] }}">{% endif %}
                                    {{ creator['rdfs:label'] }}{% if creator['role'] %} ({{ creator['role'] }}){% endif %}
                                    {% if creator['@id'] %}</a>{% endif %}
                                </li>
                            {% endfor %}
                        </ol>
                    </dd>
                {% endif %}

                {% if record['dcterms:created'] or record['dbo:productionStartYear']
                    or record['dbpedia-owl:constructionMaterial'] or record['dbpedia-owl:technique'] %}
                	<dt>{_ Date _}</dt>
                	<dd>
                		{# TODO filter date for friendlier dates #}
                        {% with
                            record['dbo:productionStartYear']|default:record['dcterms:created']|isodate:"j F Y",
                            record['dbo:productionEndYear']|isodate:"j F Y"
                        as
                            start,
                            end
                        %}
                            {{ start }}{% if end and end != start %} – {{ end }}{% endif %}
                        {% endwith %}
                	</dd>
                {% endif %}

	            {% if record['production.place'] %}
	            	<dt>{_ Produced in _}</dt>
	            	<dd>{{ record['production.place'] }}</dd>
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

        {% include "beeldenzoeker/metadata/geo.tpl" places=record['dcterms:spatial'] %}

        <div class="adlib-object__meta__row">
            <div class="adlib-object__meta__title">
                {_ Acquisition & License _}
            </div>
            <dl class="adlib-object__meta__data">
            {% if record['acquisition.date'] %}
                <dt>{_ Acquired _}</dt>
                <dd>{{ record['acquisition.date']|isodate:"j F Y" }}{% if record['acquisition.method'] %}, {{ record['acquisition.method'] }}{% endif %}</dd>
            {% endif %}

            {% if record['dcterms:license'] or record['copyright'] %}
                <dt>{_ License _}</dt>
                <dd>
                    {% if record['dcterms:license'] as license %}
                        <a href="{{ license }}">CC {{ m.creative_commons[license].label }}</a>
                    {% elseif record['copyright'] as license %}
                        {{ license }}
                    {% endif %}
                </dd>
            {% endif %}

            {% if record['credit_line'] %}
                <dt>{_ Credit line _}</dt>
                <dd>{{ record['credit_line'] }}</dd>
            {% endif %}
	        </dl>
	    </div>

        {% optional include "collection/metadata/reproduction.tpl" %}

        {% if m.acl.is_allowed.view.internal_adlib_content %}
            <div class="adlib-object__meta__row">
                <div class="adlib-object__meta__title">
                    {_ Internal _}
                </div>
                <dl class="adlib-object__meta__data">
                    {% optional include "beeldenzoeker/metadata/internal.tpl" %}

                    {% if record['dbpedia-owl:notes'] as notes %}
                        <dt>{_ Notes _}</dt>
                        <dd>
                            <ul>
                            {% for note in notes %}
                                <li>{{ note }}</li>
                            </ul>
                            {% endfor %}
                        </dd>
                    {% endif %}
                </dl>
            </div>
        {% endif %}

	    {% if record.uri as uri %}
		    <div class="adlib-object__meta__row last">
		        <div class="adlib-object__meta__title">
		            {_ Sustainable web address _}
		        </div>
		        <div class="adlib-object__meta__data">
	                {_ If you want to refer this object then use this URL _}
	                <a href="{{ uri }}" target="_blank">{{ uri }} <i class="icon--external"></i></a>
		        </div>
		    </div>
		{% endif %}
	</div>
</div>
