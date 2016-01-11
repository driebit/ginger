{% extends "ginger_edit_base.tpl" %}

{% block title %}{_ Edit _}{% if id %}: {{ id.title|default:"-" }}{% endif %}{% endblock%}

{% block page_class %}ginger-edit{% endblock %}

{% block header %}
    {# The buttons in the navbar click/sync with hidden counter parts in the resource edit form #}
    <header class="ginger-edit__header">
        <nav class="ginger-edit__nav navbar navbar-savebuttons">
            {% button class="btn ginger-edit-save btn--save" text=_"Save" title=_"Save"
                      action={script script="$('#save_view').click();"}
            %}

            {% button class="btn--cancel" text=_"Cancel" action={redirect back} tag="a" %}
        </nav>
        {% block header_text %}
            <h1 class="page-title">{_ Edit _}: {% if id.name_first %} {{ id.name_first }} {% if id.name_surname %} {{ id.name_surname }}{% endif %}{% elif id.title %}{{ id.title }}{% else %}{{ id.category.name }}{% endif %}</h1>
        {% endblock %}
    </header>
{% endblock %}

{% block content %}
    {% if id.is_editable %}
        <form id="rscform" method="post" action="postback" class="form">
        <div class="row page-ginger_edit_content_row_class">
            <div class="col-sm-8 col-md-8">
                {% catinclude "_ginger_edit.tpl" id %}
            </div>

            <div class="col-sm-4 col-md-4">
                {% catinclude "_aside_ginger_edit.tpl" id page="edit" %}
            </div>
        </div>
        </form>
    {% else %}
        <h2>{_ Not allowed _}</h2>
         <a href="/">{_ Go to _} {_ Home _}</a>
    {% endif %}
{% endblock %}

{% block footer %}
    <nav class="ginger-edit__nav--footer">
        <div class="navbar-inner row">
            <div class="col-xs-12" id="save-buttons">
                {% ifnotequal id 1 %}
                    {% button class="btn--delete" disabled=(r.is_protected or not m.rsc[id].is_deletable) id="delete-button" text=_"Delete" action={dialog_delete_rsc id=id.id on_success={redirect back}} title=_"Delete this page." %}
                {% endifnotequal %}

                {% button class="btn--save" text=_"Save" title=_"Save"
                          action={script script="$('#save_view').click();"}
                 %}

                {% button class="btn--cancel" text=_"Cancel" action={redirect back} tag="a" %}
                {#  <a href="{{ id.page_url }}" class="btn">{_ Close _}</a> #}
            </div>
        </div>
    </nav>
{% endblock %}
