<div class="adlib-object__meta">
	<div class="main-container">
	    <div class="adlib-object__meta__row first">
	        <div class="adlib-object__meta__title">
	            {_ Identification _}
	        </div>
	        <dl class="adlib-object__meta__data">
	        	<dt>{_ Title _}</dt>
	        	<dd>{% include "beeldenzoeker/title.tpl" title=record.title|default:record['dcterms:title'] %}</dd>
	            {% if record.object_category %}
	            	<dt>{_ Object type _}</dt>
	            	<dd>{{ record.object_category.value|default:record.object_category }}</dd>
		        {% endif %}
	            {% if record.object_name %}
	            	<dt>{_ Object name _}</dt>
	            	<dd>{{ record.object_name }}</dd>
		        {% endif %}
	            {% if record['dcterms:identifier'] %}
	            	<dt>{_ Object nr. _}</dt>
	            	<dd>{{ record['dcterms:identifier'] }}</dd>
		        {% endif %}
	            {% if record.collection %}
	            	<dt>{_ Collection _}</dt>
	            	<dd>{{ record.collection }}</dd>
	            {% endif %}
	        </dl>
	    </div>
	    <div class="adlib-object__meta__row">
	        <div class="adlib-object__meta__title">
	            {_ Manufacture _}
	        </div>
	        <dl class="adlib-object__meta__data">
	        	{% if record.maker[1]['creator.name']|default:record['creator.name'] as creator %}
	        		<dt>{_ Creator _}</dt>
	        		<dd>{{ creator }} {% if record.maker[1]['creator.role'] %}({{record.maker[1]['creator.role'] }}){% endif %}</dd>
		        {% endif %}
                {% if record['dcterms:created'] or record['dbo:productionStartYear'] %}
                	<dt>{_ Date _}</dt>
                	<dd>
                		{# TODO filter date for friendlier dates #}
                        {% with
                            record['dbo:productionStartYear']|default:record['dcterms:created'],
                            record['dbo:productionEndYear']
                        as
                            start,
                            end
                        %}
                            {{ start }}{% if end and end != start %} – {{ end }}{% endif %}
                        {% endwith %}
                	</dd>
                {% endif %}

	            {% if record['production.place'] %}
	            	<dt>{_ City _}</dt>
	            	<dd>{{ record['production.place'] }}</dd>
	            {% endif %}
	        </dl>
	    </div>
	    {% if record.material or record.technique or record.dimension[1]['dimension.value'] %}
		    <div class="adlib-object__meta__row">
		        <div class="adlib-object__meta__title">
		            {_ Material & Technique _}
		        </div>
		        <dl class="adlib-object__meta__data">
		        	{% if record.material %}
		        		<dt>{_ Material _}</dt>
		        		<dd>{{ record.material }}</dd>
			        {% endif %}
			        {% if record.technique %}
			        	<dt>{_ Technique _}</dt>
			        	<dd>{{ record.technique }}</dd>
			        {% endif %}
			        {% if record.dimension[1]['dimension.value'] %}
			        	<dt>{_ Dimensions _}</dt>
			        	<dd>h {{ record.dimension[1]['dimension.value'] }} {{ record.dimension[1]['dimension.unit'] }} x b {{ record.dimension[3]['dimension.value'] }} {{ record.dimension[3]['dimension.unit'] }}</dd>
			        {% endif %}
		        </dl>
		    </div>
		{% endif %}
	    <div class="adlib-object__meta__row">
	        <div class="adlib-object__meta__title">
	            {_ Acquisition & License _}
	        </div>
	        <dl class="adlib-object__meta__data">
	        	{% if record.credit_line %}
	        		<dt>{_ Credit line _}</dt>
	        		<dd>{{ record.credit_line }}</dd>
		        {% endif %}
		        {% if record['acquisition.date'] %}
		        	<dt>{_ Aquisition _}</dt>
		        	<dd>{{ record['acquisition.date'] }}{% if record['aquisition.method'] %}, {{ record['aquisition.method'] }}{% endif %}</dd>
		        {% endif %}
            	<dt>{_ License _}</dt>
            	<dd></dd>
	        </dl>
	    </div>
	    {% if record.persistent_ID %}
		    <div class="adlib-object__meta__row last">
		        <div class="adlib-object__meta__title">
		            {_ Sustainable web address _}
		        </div>
		        <div class="adlib-object__meta__data">
	                {_ If you want to refer this object then use this URL _}
	                <a href="{{ record.persistent_ID }}" target="_blank">{{ record.persistent_ID }} <i class="icon--external"></i></a>
		        </div>
		    </div>
		{% endif %}
	</div>
</div>
