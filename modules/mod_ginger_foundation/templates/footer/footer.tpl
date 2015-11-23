<footer class="main-footer">
    <div class="main-footer__container">
        {% menu menu_id=m.rsc.footer_menu.id id=id context=context menu_class="main-footer__nav" %}

        {% include "footer/footer-social.tpl" id=id %}

        {% include "footer/footer-copyrights.tpl" id=id %}
    </div>
</footer>
