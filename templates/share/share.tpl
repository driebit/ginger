<div class="share">
    {% block button %}
        <button class="share__button">
            {_ Delen _} 
        </button>
    {% endblock %}
    {% block menu %}
        <ul class="share__menu">
            <li>
                <a href="http://www.facebook.com/sharer.php?u=http%3A%2F%2F{{ m.site.hostname }}{{ id.page_url|urlencode }}&amp;t={{ id.title|urlencode }}" onclick="return !window.open(this.href, 'Facebook', 'width=600,height=500,toolbar=0,location=0,scrollbars=0,status=0')" title="Facebook" class="">{_ Facebook _}</a>
            </li>
            <li>
                <a href="https://twitter.com/share?text={{ id.title|urlencode }}&amp;lang={{ z_language }}" onclick="return !window.open(this.href, 'Twitter', 'width=600,height=300,location=0,toolbar=0,scrollbars=0,status=0')" title="Twitter" class="">{_ Twitter _}</a>
            </li>
            <li>
                <a href="https://www.linkedin.com/shareArticle?mini=true&amp;title={{ id.title|urlencode }}&amp;url={{ id.page_url_abs|urlencode }}" onclick="return !window.open(this.href, 'LinkedIn', 'width=600,height=300,location=0,toolbar=0,scrollbars=0,status=0')" title="LinkedIn" class="">{_ LinkedIn _}</a>
            </li>
            <li>
                <a href="mailto:?subject={{ id.title|urlencode }}&amp;body={{ id.page_url_abs|urlencode }}" title="Email" class="">{_ Email _}</a>
            </li>
        </ul>
    {% endblock %}
</div>