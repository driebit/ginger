<ul class="person-details">
    {% if person.email %}
        <li class="person-detail--email">
            <span class="person-detail__icon"><i class="icon--envelope"></i></span>
            <span class="person-detail__label">{_ E-mail _}</span>
            <a class="" href="mailto:{{ person.email }}">{{ person.email }}</a>
        </li>
    {% endif %}

    {% if person.website %}
        <li class="person-detail--website">
            <span class="person-detail__icon"><i class="icon--pointer"></i></span>
            <span class="person-detail__label">{_ Website _}</span>
            <a class="" href="{{ person.website }}">{{ person.website }}</a>
        </li>
    {% endif %}

    {% if person.phone %}
        <li class="person-detail--phone">
            <span class="person-detail__icon"><i class="icon--phone-horn"></i></span>
            <span class="person-detail__label">{_ Telefoon _}</span>
            <a class="" href="tel:{{ person.phone }}">{{ person.phone }}</a>
        </li>
    {% endif %}

    {% if person.phone_mobile %}
        <li class="person-detail--mobile">
            <span class="person-detail__icon"><i class="icon--phone-horn"></i></span>
            <span class="person-detail__label">{_ Mobiel _}</span>
            <a class="" href="tel:{{ person.phone_mobile }}">{{ person.phone_mobile }}</a>
        </li>
    {% endif %}

    {% if person.facebook %}
        <li class="person-detail--facebook">
            <span class="person-detail__icon"><i class="icon--facebook"></i></span>
            <span class="person-detail__label">{_ Facebook _}</span>
            <a class="" href="tel:{{ person.phone_mobile }}">{{ person.facebook }}</a>
        </li>
    {% endif %}

</ul>