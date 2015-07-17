<a id="{{ #profile }}" href="" class="global-nav__actions__profile">
    profile <i class="icon--profile"></i>
</a>

{% wire
    id=#profile
    action={
        dialog_open
        title=_"Profiel"
        template="profile-menu/profile-menu.tpl"
    }
%} 