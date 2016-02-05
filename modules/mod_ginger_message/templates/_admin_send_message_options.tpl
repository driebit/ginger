{% wire id="category"++category.id type="click" postback={linkmessage message=id category=category.id} delegate="resource_message_link_category_to_message" %}
<div class="checkbox">
    <label><input id="category{{ category.id }}" type="checkbox" {% if category.id|member:m.rsc[id].o.send_message %}checked="checked"{% endif %} />{{ category.indent }}{{ m.rsc[category.id].title }}</label>
</div>
