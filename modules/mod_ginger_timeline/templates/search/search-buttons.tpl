<a href="#timeline" class="btn--result-option"><i class="icon--timeline"></i>{_ timeline _}</a>

{% wire
    name="search-timeline"
    action={update target="search-timeline" text="<p style='margin-top:20px'>Loading...</p>"}
    action={update
        target="search-timeline"
        template="search/search-query-wrapper.tpl"
        cg_name="default_content_group"
    }
%}
