{% with
    (remarks|length / page_length)|ceiling
as
    total_pages
%}

{% if total_pages > 1 %}
    <div class="remark__pager">
        <div class="remark__pager__pagination">
            <ul class="pagination pagination-centered">
                {% if page - 1 > 0 %}
                    <li><a href="?remark_page={{ page - 1}}&remark_page_length={{ page_length }}#remarks" title="{_ Previous page _}">←</a></li>
                    {% if page - 1 > 2 %}
                        <li><a href="?remark_page=1&remark_page_length={{ page_length }}#remarks">1</a></li>
                        <li class="disabled"><a href="#content-pager">…</a></li>
                    {% endif %}
                {% else %}
                    <li class="disabled"><a href="#content-pager">←</a></li>
                {% endif %}
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
                        {% if page != total_pages %}
                            <li class="disabled"><a href="#content-pager">…</a></li>

                            <li><a href="?remark_page={{ total_pages }}&remark_page_length={{ page_length }}#remarks">{{ total_pages }}</a></li>
                        {% endif %}
                {% if total_pages > page %}
                    <li><a href="?remark_page={{ page + 1}}&remark_page_length={{ page_length }}#remarks" title="{_ Next page _}">→</a></li>
                {% else %}
                    <li class="disabled"><a href="#content-pager">→</a></li>
                {% endif %}
            </ul>
        </div>
    </div>
{% endif %}
{% endwith %}
