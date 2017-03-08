<div class="adlib-object__meta">
	<div class="main-container">
	    <div class="adlib-object__meta__row first">
	        <div class="adlib-object__meta__title">
	            {_ Identification _}
	        </div>
	        <ul class="adlib-object__meta__data">
	            <li>
	                <b>{_ Title _}</b><span>{% include "beeldenzoeker/title.tpl" title=record.title|default:record['dcterms:title'] %}</span>
	            </li>
	            {% if record.object_category %}
		            <li>
		                <b>{_ Object type _}</b><span>{{ record.object_category.value|default:record.object_category }}</span>
		            </li>
		        {% endif %}
	            {% if record.object_name %}
		            <li>
		                <b>{_ Object name _}</b><span>{{ record.object_name }}</span>
		            </li>
		        {% endif %}[
	            {% if record['dcterms:identifier'] %}
		            <li>
		                <b>{_ Object nr. _}</b><span>{{ record['dcterms:identifier']}}</span>
		            </li>
		        {% endif %}
	            {% if record.collection %}
	                <li>
	                    <b>{_ Collection _}</b><span>{{ record.collection }}</span>
	                </li>
	            {% endif %}
	        </ul>
	    </div>
	    <div class="adlib-object__meta__row">
	        <div class="adlib-object__meta__title">
	            {_ Manufacture _}
	        </div>
	        <ul class="adlib-object__meta__data">
	        	{% if record.maker[1]['creator.name']|default:record['creator.name'] as creator %}
		            <li>
		                <b>{_ Creator _}</b><span>{{ creator }} {% if record.maker[1]['creator.role'] %}({{record.maker[1]['creator.role'] }}){% endif %}</span>
		            </li>
		        {% endif %}
	            {% if record['production.date.start'] or record['production_date']or record['production.date.end'] %}
		            <li>
		                <b>{_ Dating _}</b>{% if record['production.date.start']|default:record['production_date'] as production_date %}<span>{{ production_date }}{% if record['production.date.end'] and record['production.date.end'] != record['production.date.start'] %} – {{ record['production.date.end'] }}{% endif %}</span>{% endif %}
		            </li>
		        {% endif %}
	            {% if record['production.place'] %}
	                <li>
	                    <b>{_ City _}</b><span>{{ record['production.place'] }}</span>
	                </li>
	            {% endif %}
	        </ul>
	    </div>
	    {% if record.material or record.technique or record.dimension[1]['dimension.value'] %}
		    <div class="adlib-object__meta__row">
		        <div class="adlib-object__meta__title">
		            {_ Material & Technique _}
		        </div>
		        <ul class="adlib-object__meta__data">
		        	{% if record.material %}
			            <li>
			                <b>{_ Material _}</b><span>{{ record.material }}</span>
			            </li>
			        {% endif %}
			        {% if record.technique %}
			            <li>
			                <b>{_ Technique _}</b><span>{{ record.technique }}</span>
			            </li>
			        {% endif %}
			        {% if record.dimension[1]['dimension.value'] %}
			            <li>
			                <b>{_ Dimensions _}</b><span>h {{ record.dimension[1]['dimension.value'] }} {{ record.dimension[1]['dimension.unit'] }} x b {{ record.dimension[3]['dimension.value'] }} {{ record.dimension[3]['dimension.unit'] }} </span>
			            </li>
			        {% endif %}
		        </ul>
		    </div>
		{% endif %}
	    <div class="adlib-object__meta__row">
	        <div class="adlib-object__meta__title">
	            {_ Acquisition & License _}
	        </div>
	        <ul class="adlib-object__meta__data">
	        	{% if record.credit_line %}
		            <li>
		                <b>{_ Credit line _}</b><span>{{ record.credit_line }}</span>
		            </li>
		        {% endif %}
		        {% if record['acquisition.date'] %}
		            <li>
		                <b>{_ Aquisition _}</b><span>{{ record['acquisition.date'] }}{% if record['aquisition.method'] %}, {{ record['aquisition.method'] }}{% endif %}</span>
		            </li>
		        {% endif %}
	            <li>
	                <b>{_ License _}</b><span></span>
	            </li>
	        </ul>
	    </div>
	    {% if record.persistent_ID %}
		    <div class="adlib-object__meta__row last">
		        <div class="adlib-object__meta__title">
		            {_ Sustainable web address _}
		        </div>
		        <ul class="adlib-object__meta__data">
		            <li>
		                {_ If you want to refer this object then use this URL _}
		                <a href="{{ record.persistent_ID }}" target="_blank">{{ record.persistent_ID }} <i class="icon--external"></i></a>
		            </li>
		        </ul>
		    </div>
		{% endif %}
	</div>
</div>
