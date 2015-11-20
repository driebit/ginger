<footer class="main-footer">
    <div class="main-footer__container">
        {% menu menu_id=m.rsc.footer_menu.id id=id context=context menu_class="main-footer__nav" %}

        {% include "footer/footer-social.tpl" %}

        {% include "footer/footer-copyrights.tpl" %}

        {% optional include "footer/footer-newsletter-form.tpl" id=id %}
    </div>
</footer>
