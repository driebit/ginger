{% with
    (remarks|length / page_length)|ceiling
    as
    total_pages
     %}

{% if total_pages > 1 %}
    <div class="remark__pager">
        <div class="remark__pager__result-counter">{{ remarks|length }} {_ results _}</div>
        <div class="remark__pager__pagination">
            <ul class="pagination pagination-centered">
                {% if page - 1 > 0 %}
                    <li><a href="?remark_page={{ page - 1}}&remark_page_length={{ page_length }}#remarks">←</a></li>
                {% else %}
                    <li class="disabled"><a href="#content-pager">←</a></li>
                {% endif %}
                        <!-- <li><a href="/search?page=1#content-pager">1</a></li>
                        <li class="disabled"><a href="#">…</a></li> -->
                        {% if (page - 2) > 0 %}
                        <li><a href="?remark_page={{ page - 2 }}&remark_page_length={{ page_length }}#remarks">{{ page - 2 }}</a></li>
                        {% endif %}
                        {% if (page - 1) > 0 %}
                        <li><a href="?remark_page={{ page - 1 }}&remark_page_length={{ page_length }}#remarks">{{ page - 1 }}</a></li>
                        {% endif %}
                        <li class="active"><span>{{ page }}</span></li>
                        {% if (page + 1) <= total_pages %}
                        <li><a href="?remark_page={{ page + 1 }}&remark_page_length={{ page_length }}#remarks">{{ page + 1 }}</a></li>
                        {% endif %}
                        {% if (page + 2) <= total_pages %}
                        <li><a href="?remark_page={{ page + 2 }}&remark_page_length={{ page_length }}#remarks">{{ page + 2 }}</a></li>
                        {% endif %}
                        <!-- <li class="disabled"><a href="#">…</a></li>
                        <li><a href="/search?page=3000#content-pager">3000</a></li> -->
                {% if total_pages > page %}
                    <li><a href="?remark_page={{ page + 1}}&remark_page_length={{ page_length }}#remarks">→</a></li>
                {% else %}
                    <li class="disabled"><a href="#content-pager">→</a></li>
                {% endif %}
            </ul>
        </div>
    </div>
{% endif %}
{% endwith %}
