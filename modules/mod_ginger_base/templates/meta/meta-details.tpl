<ul class="person-details">
    {% if id.email %}
        <li class="person-detail--email">
            <span class="person-detail__label">
                <i class="icon--envelope"></i>
                {_ E-mail _}:
            </span>
            {% include "mailto/mailto.tpl" address=id.email text=_"email" %}
        </li>
    {% endif %}

    {% if id.phone %}
        <li class="person-detail--phone">
            <span class="person-detail__label">
                <i class="icon--phone-horn"></i>
                {_ Telephone number _}:
            </span>
            <a class="person-detail__link" href="tel:{{ id.phone }}">{{ id.phone }}</a>
        </li>
    {% endif %}

    {% if id.phone_mobile %}
        <li class="person-detail--mobile">
            <span class="person-detail__label">
                <i class="icon--mobile"></i>
                {_ Mobile number _}:
            </span>
            <a class="person-detail__link" href="tel:{{ id.phone_mobile }}">{{ id.phone_mobile }}</a>
        </li>
    {% endif %}

     {% if id.website %}
        <li class="person-detail--website">
            <span class="person-detail__label">
                <i class="icon--pointer"></i>
                {_ Website _}:
            </span>
            <a class="person-detail__link" href="{{ id.website }}">{_ Go to website _}</a>
        </li>
    {% endif %}

     {% if id.facebook %}
        <li class="person-detail--facebook">
            <span class="person-detail__label">
                <i class="icon--facebook"></i>
                {_ Facebook _}:
            </span>
            <a class="person-detail__link" href="{{ id.facebook }}">{_ Go to Facebook _}</a>
        </li>
    {% endif %}

    {% if id.linkedin %}
        <li class="person-detail--linkedin">
            <span class="person-detail__label">
                <i class="icon--linkedin"></i>
                {_ LinkedIn _}:
            </span>
            <a class="person-detail__link" href="{{ id.linkedin }}">{_ Go to LinkedIn _}</a>
        </li>
    {% endif %}

      {% if id.twitter %}
        <li class="person-detail--twitter">
            <span class="person-detail__label">
                <i class="icon--twitter"></i>
                {_ Twitter _}:
            </span>
            <a class="person-detail__link" href="{{ id.twitter }}">{_ Go to Twitter _}</a>
        </li>
    {% endif %}
</ul>
