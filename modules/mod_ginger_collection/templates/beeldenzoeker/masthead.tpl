{% if url %}
    <div class="masthead {{ extraClasses }}" style="background-image: url({{ url }});">
        <a href="{{ url }}" class="masthead__zoom" title="{_ Zoom _}"><i class="icon--expand"></i></a>
    </div>
{% else %}
    <div class="masthead no-image"></div>
{% endif %}
