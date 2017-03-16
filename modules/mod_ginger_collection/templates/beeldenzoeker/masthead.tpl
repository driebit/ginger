{% if url %}
    <a href="{{ url }}" class="masthead {{ extraClasses }} masthead__zoom" style="background-image: url({{ url }});">
        <button class="masthead__zoom-btn" title="{_ Zoom _}"><i class="icon--expand"></i></button>
    </a>
{% else %}
    <div class="masthead no-image"></div>
{% endif %}
