{% if m.acl.is_allowed.use.mod_admin_identity %}

    <ul class="tree-list" id="rfid-list">
        {% for rfid in m.identity[id].all.rfid %}
            <li class="menu-item">
                <div>
                    <span>
                        <span class="menu-label">{{ rfid.key }}</span>
                        <span class="category">{{ rfid.created|date:"j M Y H:i" }}</span>
                        <span class="btns">
                            <span class="btn-group">
                                <a href="#" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown"><i class="glyphicon glyphicon-cog"></i> <span class="caret"></span></a>
                                <ul class="dropdown-menu dropdown-menu-right">
                                    {% wire id=#remove_rfid++rfid.id postback={delete rfid=rfid.key id=id} delegate=`mod_ginger_tagger` %}
                                    <li><a href="#" id="{{ #remove_rfid++rfid.id }}">{_ Delete _}</a></li>
                                </ul>
                            </span>
                          </span>
                    </span>
                </div>
            </li>
        {% endfor %}
    </ul>

    <div class="form-group">
        {% button class="btn btn-default" text=_"Add RFID" ++ "..." action={dialog_open title=_"Add RFID" template="admin/add-rfid.tpl" id=id} %}
    </div>

{% endif %}
