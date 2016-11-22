{% if id.s.interest as interested %}
    <div class="page-actions__interested">
        <a href="test"><i class="icon--heart"></i> {% include "number-of/number-of.tpl" items=interested none=_"no interested people" singular=_"1 person interested" plural=_"interested people" %}</a>
    </div>
{% endif %}
