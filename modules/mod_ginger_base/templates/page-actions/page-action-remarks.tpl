{% if m.modules.active.mod_ginger_remark %}
    {% if id.s.about|is_a:"remark" as remarks %}
        <div class="page-actions__comments">
            <a href="#remarks" class="do_anchor">
                <i class="icon--comment"></i> {% include "remark/remark-number-of.tpl" %}
            </a>
        </div>
    {% endif %}
{% endif %}
