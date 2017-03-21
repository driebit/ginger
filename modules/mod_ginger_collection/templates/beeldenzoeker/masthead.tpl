{% if url %}
    <a href="{{ url }}" class="masthead {{ extraClasses }} masthead__zoom" style="background-image: url({{ url }});">
        <button class="masthead__zoom-btn" title="{_ Zoom _}"><i class="icon--expand"></i></button>
        <div class="masthead__img"></div>
        <div class="masthead__blur"></div>
    </a>
{% else %}
    <div class="masthead no-image"></div>
{% endif %}
