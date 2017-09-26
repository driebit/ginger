<a href="{{ url }}"{% if link_target %} target="{{ link_target }}"{% endif %}>
    <div class="readmore {{ class }}">
        <div class="readmore-text">
            <div class="readmore-title">
                {{ text|default:_"Read more" }}
            </div>
            <div class="readmore-hostname">
                {{ source }}
            </div>
        </div>
        <div class="readmore-arrow">
            <div class="collection-icon arrow-right"></div>
        </div>
    </div>
</a>
