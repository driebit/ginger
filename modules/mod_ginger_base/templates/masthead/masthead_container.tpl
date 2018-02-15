{% with  dep as dep %}
      <div 
            class="masthead do_parallax {{ extraClasses }}" 
            style="
                background-image: url({% image_url dep mediaclass='masthead' crop=dep.crop_center %}); 
                background-size: cover; 
                background-position: {{ dep|background_position }};
            ">
        </div>
{% endwith %}
