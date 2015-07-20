<a id="{{ #language }}" href="#" class="global-nav__actions__language">
    <i class="icon--language"></i> {{ z_language }}
</a>

{% wire
    id=#language
    action={
        dialog_open
        title=_"Taalkeuze"
        template="language-menu/language-menu.tpl"
    }
%}
