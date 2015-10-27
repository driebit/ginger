 <form class="home__search" role="search" action="{% url search %}" method="get">
    <div class="main-container">
        <input type="hidden" name="qsort" value="{{ q.qsort|escape }}" />
        <input type="hidden" name="qcat" value="{{ q.qcat|escape }}" />
        <input type="text" placeholder="{{ placeholder_text }}" class="search-query" name="qs" value="{{q.qs|escape}}" autocomplete="off">
        <button type="submit" class="btn--search" title="{_ Search _}"><i class="icon--search"></i> {_ search _}</button>
    </div>
</form>
