<div class="form-group">
    <div>
        {% button class="btn btn-default" text=_"Delete Adlib page index..."
            action={confirm text=[
                                _"Are you sure you want to delete the Adlib index?",
                                "<br><br>",
                                _"You will need to reimport all documents to fill it again."
                            ]
                            ok=_"Delete"
                            is_danger
                            postback={delete_index}
                            delegate=`mod_ginger_adlib_elasticsearch2`}
        %}
        <span class="help-block">{_ Sometimes the Elastic Search index can get out of sync with Adlib. This will delete and recreate an empty Elastic Search index. _}</span>
    </div>
</div>
