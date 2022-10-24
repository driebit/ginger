{% if q.query_id and q.current %}
    {% with index|default:(m.ginger_collection.collection_index ++ "," ++ m.ginger_collection.default_index) as index %}
    {% with search|collection_query_pager:index:q.query_id:q.current as prevnext %}
    {% with prevnext|first as prev %}
    {% with prevnext|last as next %}
        <div class="collection-nav">
        {% if prev|is_defined %}
            <a class="collection-nav__btn -prev" href="{{ prev|collection_object_url }}?query_id={{ q.query_id|escape }}&total={{ q.total|escape }}&current={{ q.current|escape|to_integer - 1 }}"><i class="icon--arrow-left"></i> <span>{_ Previous _}</span></a>
        {% else %}
            <div class="collection-nav__btn -disabled"></div>
        {% endif %}
        <a href="{{ m.rsc[q.query_id].page_url }}" class="collection-nav__title">{{ m.rsc[q.query_id].title }} <span>{{ q.current|escape }} / {{ q.total|escape }}</span></a>
        {% if next|is_defined %}
            <a class="collection-nav__btn -next" href="{{ next|collection_object_url }}?query_id={{ q.query_id|escape }}&total={{ q.total|escape }}&current={{ q.current|escape|to_integer + 1 }}"><span>{_ Next _}</span> <i class="icon--arrow-right"></i></a>
        {% else %}
            <div class="collection-nav__btn -disabled"></div>
        {% endif %}
        </div>
    {% endwith %}
    {% endwith %}
    {% endwith %}
    {% endwith %}
{% endif %}
