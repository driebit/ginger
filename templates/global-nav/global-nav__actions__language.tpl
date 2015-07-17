<a id="{{ #language }}" href="#" class="global-nav__actions__language">
    LANG <i class="icon--language"></i>
</a>

{% wire
    id=#language
    action={
        dialog_open
        title=_"Taalkeuze"
        template="language-menu/language-menu.tpl"
    }
%}
