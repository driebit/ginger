<div class="tab-pane" id="{{ tab }}-linked-data">
    <div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-find">
    	<form id="dialog-connect-find-linked-data" class="row form form-horizontal">
    		<input type="hidden" name="subject_id" value="{{ subject_id }}" />
    		<input type="hidden" name="predicate" value="{{ predicate|default:'' }}" />

            <div class="col-md-8">
    		    <input name="find_text" type="text" value="{{ text|default:'' }}" placeholder="{_ Search linked data _}" class="do_autofocus form-control" />
            </div>

            <div class="col-md-4">

    		    {% block category_select %}
    		        <select class="form-control" name="find_category">
    			        {% if predicate %}
    				        <option value="p:{{ predicate }}">{_ Valid for: _} {{ predicate.title }}</option>
    			        {% endif %}
    			        <option value="">{_ Any category _}</option>
    			        <option value="" disabled></option>
                        <option value="event">RDF event</option>
                        <option value="person">RDF person</option>
    		        </select>
    	        {% endblock %}
            </div>
    	</form>

    	<div id="dialog-connect-found-linked-data" class="do_feedback"
    		data-feedback="trigger: 'dialog-connect-find-linked-data', delegate: 'mod_ginger_rdf', template: '_action_dialog_connect_tab_find_linked_data_results.tpl'">
    	</div>
    </div>
    {% wire name="dialog_connect_find_linked_data"
        action={postback
            delegate="mod_ginger_rdf"
            postback={admin_connect_select
                id=id
                subject_id=subject_id
                predicate=predicate
                callback=callback
                language=language
                action=action
                actions=actions
            }
        }
    %}
    {% javascript %}
        $('#dialog-connect-find-linked-data').change();
        $("#dialog-connect-found-linked-data").on('click', '.thumbnail', function(e) {
        	e.preventDefault();
            z_event('dialog_connect_find_linked_data', {
                object_props: $(this).data(),
                object: $(this).data('uri'),
                object_title: $(this).data('title')
            });
        });
    {% endjavascript %}

</div>
