{% include "search-suggestions/toggle-search.tpl" %}
{% include "toggle-menu/toggle-menu.tpl" %}
<div class="global-nav__actions cf">
    {% optional include "_auth_link.tpl" class="login--global-nav" label_class=" " icon="icon--person" icon_before %}
    {% include "dialog-profile/button-profile.tpl" %}
    {% include "dialog-language/button-language.tpl" raw_path=m.req.raw_path %}
</div>
{% include "search-suggestions/search.tpl" identifier="global-nav" %}
