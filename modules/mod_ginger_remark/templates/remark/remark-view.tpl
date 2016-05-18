    <li class="remark-item {{ extraClasses }}">
        {% include "page-actions/page-action-edit-thing.tpl" extraClasses="edit-button--list-item" id=id %}
        <article>
            <div class="remark-item__author">
                    {% if remark_id.o.author as author %}
                        {% include "avatar/avatar.tpl" %}
                    {% else %}
                        {% include "avatar/avatar.tpl" author=m.rsc[remark_id.creator_id] %}
                    {% endif %}
                <div class="remark-item__author__text">

                    {% if remark_id.o.author as author %}
                        <b>{{ author.title }}</b>
                    {% else %}
                        <b>{{ m.rsc[remark_id.creator_id].title }}</b>
                    {% endif %}
                    {# remark_id.created|timesince:remark_id.modified:"":1 #}
                    <time datetime="{{ remark_id.created|date:"Y-F-jTH:i" }}">{{ remark_id.created|date:"d F Y" }}</time>
                </div>
            </div>

            <div class="remark-item__content">
                <h3 class="remark-item__content__title">
                    {{ remark_id.title }}
                </h3>
                <div class="remark-item__content__body">
                    {{ remark_id.body|show_media }}
                </div>
                {% with remark_id.media|without_embedded_media:id|first as dep %}
                    {% catinclude "media/media.image.tpl" dep %}
                {% endwith %}

                {% block about %}
                    {% if remark_id.id != remark_id.o.comment.id %}
                        <p>
                            <i class="icon--comment"></i>Dit is een reactie op: <a href="{{ remark_id.o.about.page_url }}"> {{ remark_id.o.about.title }}</a>
                        </p>
                    {% endif %}
                {% endblock %}
            </div>

            <div class="buttons">
                <a href="#" class="remark-edit">edit</a>
                <a href="#" class="remark-delete">delete</a>
            </div>
        </article>
    </li>


</div>

{% javascript %}
    $(document).trigger('remark:viewing');
{% endjavascript %}

{% wire name="rsc_delete_"++remark_id action={dialog_delete_rsc id=remark_id on_success={script script="$(document).trigger('remark:delete', " ++ remark_id ++ ");"}} %}
