<footer class="main-footer">
    <div class="main-footer__container">
        {% menu menu_id=m.rsc.footer_menu.id id=id context=context menu_class="main-footer__nav" %}

        {% include "footer/footer-social.tpl" %}

        <div class="main-footer__column">

            {% optional include "footer/footer-newsletter-form.tpl" id=id %}

            {% include "footer/footer-copyrights.tpl" %}
        </div>
    </div>
</footer>
