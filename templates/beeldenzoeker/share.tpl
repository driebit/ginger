 <div class="adlib-share">
    <button>{_ Share _}</button>
    <ul>
        <li><a href="http://www.facebook.com/sharer.php?u=http%3A%2F%2F{{ m.site.hostname }}{{ record.page_url|urlencode }}&amp;t={{ record.title|urlencode }}" onclick="return !window.open(this.href, 'Facebook', 'width=600,height=500,toolbar=0,location=0,scrollbars=0,status=0')" title="Facebook" class="">{_ Facebook _}</a></li>
        <li><a href="https://twitter.com/intent/tweet?text={{ record.title|urlencode  }}%20http%3A%2F%2F{{ m.site.hostname }}{{ record.page_url|urlencode }}&amp;t={{ record.title|urlencode }}" onclick="return !window.open(this.href, 'Twitter', 'width=600,height=300,location=0,toolbar=0,scrollbars=0,status=0')" title="Twitter" class="">{_ Twitter _}</a></li>
        <li><a href="http://pinterest.com/pin/create/button/?url={{ record.page_url_abs|urlencode }}&description={{ record.title|urlencode }}" target="_blank" title="Pinterest" class="">{_ Pinterest _}</a></li>
        <li><a href="mailto:?subject={{ record.title|urlencode }}&amp;body={{ record.page_url_abs|urlencode }}" title="{_ E-mail _}" class="">{_ E-mail _}</a></li>
    </ul>
</div>