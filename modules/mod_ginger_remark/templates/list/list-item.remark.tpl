{% if id.is_visible %}

    <li class="remark-item {{ extraClasses }}">
        {% include "page-actions/page-action-edit-thing.tpl" extraClasses="edit-button--list-item" id=id %}
        <article>
            <div class="remark-item__author">
                    {% if id.o.author as author %}
                        {% include "avatar/avatar.tpl" id=m.rsc[author] %}
                    {% else %}
                        {% include "avatar/avatar.tpl" id=m.rsc[id.creator_id] %}
                    {% endif %}
                <div class="remark-item__author__text">

                    {% if id.o.author as author %}
                        <b>{{ author.title }}</b>
                    {% else %}
                        <b>{{ m.rsc[id.creator_id].title }}</b>
                    {% endif %}
                    {# id.created|timesince:id.modified:"":1 #}
                    <time datetime="{{ id.created|date:"Y-F-jTH:i" }}">{{ id.created|date:"d F Y" }}</time>
                </div>
            </div>

            <div class="remark-item__content">
                <h3 class="remark-item__content__title">
                    {{ id.title }}
                </h3>
                <div class="remark-item__content__body">
                    {{ id.body|show_media }}
                </div>

                {% with id.media|without_embedded_media:id|first as dep %}
                    {% catinclude "media/media.image.tpl" dep %}
                {% endwith %}

                {% block about %}
                    {% if id.id != id.o.comment.id %}
                        <p>
                            <i class="icon--comment"></i>Dit is een reactie op: <a href="{{ id.o.about.page_url }}"> {{ id.o.about.title }}</a>
                        </p>
                    {% endif %}
                {% endblock %}
            </div>

            {% if remark_id.is_editable and not id.o.hasremark|index_of:remark_id.id %}
                <div class="buttons">
                    <a href="#" class="remark-edit btn--edit">edit</a>
                    <a href="#" class="remark-delete btn--delete">delete</a>
                </div>
            {% endif %}

            {% javascript %}
                $(document).trigger('remark:viewing');
            {% endjavascript %}

            {% wire name="rsc_delete_"++remark_id action={dialog_delete_rsc id=remark_id on_success={script script="$(document).trigger('remark:delete', " ++ remark_id ++ ");"}} %}
        </article>
    </li>

{% endif %}

