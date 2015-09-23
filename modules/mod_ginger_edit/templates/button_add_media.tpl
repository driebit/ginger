    <a class="btn" id="{{ #connect }}" href="#connect"><i class="icon icon-camera"></i> {_ add media item _}</a>
    {% wire id=#connect 
            action={dialog_open template="_action_dialog_connect.tpl" 
                        title=[_"Add a connection: ", m.rsc.depiction.title] 
                        subject_id=id
                        edge_template="_rsc_edge_media.tpl"
                        predicate=`depiction`
                        actions=[
                            {postback postback={reload_media rsc_id=id div_id=["links-",id|make_list,"-depiction"]}
                                      delegate="controller_admin_edit"}
                        ]}
    %}
