<a id="{{ #profile }}" href="" class="global-nav__actions__profile">
    profile <i class="icon--profile"></i>
</a>

{% wire
    id=#profile
    action={
        dialog_open
        title=_"Profiel"
        template="global-nav/global-nav__actions__profile__modal.tpl"
    }
%}