{% with m.rsc[id] as r %}
    <div class="form-group row">
	    <label class="control-label col-md-3" for="visible_for">{_ Visible for _}</label>
        <div class="col-md-7">
	        <select class="form-control" id="visible_for" name="visible_for">
		        <option value="0" {% ifequal 0 r.visible_for %}selected="selected"{% endifequal %}>{_ The whole world _}</option>
		        <option value="1" {% ifequal 1 r.visible_for %}selected="selected"{% endifequal %}>{_ Community members _}</option>
		        <option value="2" {% ifequal 2 r.visible_for %}selected="selected"{% endifequal %}>{_ Group members _}</option>
	        </select>
        </div>
    </div>

    <div class="form-group row">
	    <label class="control-label col-md-3" for="editable_for">{_ Editable for _}</label>
        <div class="col-md-7">
	        <select class="form-control" id="editable_for" name="editable_for">
		        <option value="0" {% ifequal 0 r.editable_for %}selected="selected"{% endifequal %}>{_ Person/Default _}</option>
		        <option value="2" {% ifequal 2 r.editable_for %}selected="selected"{% endifequal %}>{_ Group members _}</option>
	        </select>
        </div>
    </div>

    <div class="form-group row">
        <label class="control-label col-md-3" for="creator_id">{_ Owner _}</label>
        <div class="col-md-7">
            <select class="form-control" id="owner_id" name="owner_id">
                <option value="{{ r.creator_id }}">{{ m.rsc[r.creator_id].title }}</option>
                {% for group_id in m.search[{query cat='acl_role' sort='rsc.pivot_title'}] %}
                    <option value="{{ group_id }}" {% ifequal group_id r.creator_id %}selected="selected"{% endifequal %}>{{ m.rsc[group_id].title }}</option>
                    {% for user_id in m.rsc[group_id].o.acl_role_member %}
                        <option value="{{ user_id }}" {% ifequal user_id r.creator_id %}selected="selected"{% endifequal %}> - {{ m.rsc[user_id].title }}</option>
                    {% endfor %}
                {% endfor %}

            </select>
        </div>
    </div>
{% endwith %}
