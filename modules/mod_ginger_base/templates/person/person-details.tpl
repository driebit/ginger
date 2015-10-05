<ul class="person-details">
    {% if person.email %}
        <li class="person-detail--email">
            <span class="person-detail__label">
                <i class="icon--envelope"></i> 
                {_ E-mail _}
            </span>
            <a class="person-detail__link" href="mailto:{{ person.email }}">{{ person.email }}</a>
        </li>
    {% endif %}

    {% if person.phone %}
        <li class="person-detail--phone">
            <span class="person-detail__label">
                <i class="icon--phone-horn"></i> 
                {_ Telephone number _}
            </span>
            <a class="" href="tel:{{ person.phone }}">{{ person.phone }}</a>
        </li>
    {% endif %}   

    {% if person.phone_mobile %}
        <li class="person-detail--mobile">
            <span class="person-detail__label">
                <i class="icon--phone-horn"></i>
                {_ Mobile number _}
            </span>
            <a class="" href="tel:{{ person.phone_mobile }}">{{ person.phone_mobile }}</a>
        </li>
    {% endif %}

     {% if person.website %}
        <li class="person-detail--website">
            <span class="person-detail__label">
                <i class="icon--pointer"></i>
                {_ Website _}
            </span>
            <a class="" href="{{ person.website }}">{_ Go to website _}</a>
        </li>
    {% endif %}

     {% if person.facebook %}
        <li class="person-detail--facebook">
            <span class="person-detail__label">
                <i class="icon--facebook"></i>
                {_ Facebook _}
            </span>
            <a class="" href="{{ person.facebook }}">{_ Go to Facebook _}</a>
        </li>
    {% endif %}

    {% if person.linkedin %}
        <li class="person-detail--linkedin">
            <span class="person-detail__label">
                <i class="icon--linkedin"></i>
                {_ LinkedIn _}
            </span>
            <a class="" href="{{ person.linkedin }}">{_ Go to LinkedIn _}</a>
        </li>
    {% endif %}
    
      {% if person.twitter %}
        <li class="person-detail--twitter">
            <span class="person-detail__label">
                <i class="icon--twitter"></i>
                {_ Twitter _}
            </span>
            <a class="" href="{{ person.twitter }}">{_ Go to Twitter _}</a>
        </li>
    {% endif %} 

   

   

</ul>