{% if remark_id.is_visible %}
    {% with
        show_object|default:false
    as
        show_object
    %}

    <div class="remark-item {{ extraClasses }}" id="remark-{{ remark_id }}">
        <article>
            <div class="remark-item__author">
               <div class="remark-item__author__text">
                    {% if remark_id.o.author|default:remark_id.creator_id as author %}
                        {% if author.name == "human_user" %}
                            {% if remark_id.anonymous_email_visible %}
                                 <a href="click.to.mail" address="{{ remark_id.anonymous_email|mailencode }}" class="do_mail_decode">{{ remark_id.anonymous_name }}</a>
                            {% else %}
                                {{ remark_id.anonymous_name }}
                            {% endif %}
                        {% else %}
                            <b><a href="{{ m.rsc[author].page_url }}">{{ m.rsc[author].title }}</a></b>
                        {% endif %}
                    {% endif %}

                    <time datetime="{{ remark_id.created|date:"Y-F-jTH:i" }}">
                        {% block datetime %}{{ remark_id.created|date:"d F Y" }}{% endblock %}
                    </time>
                </div>
            </div>

            <div class="remark-item__content">
                <div class="remark-item__content__body">
                    {% if show_object %}
                        <p>{_ Reaction to: _} <a href="{{ remark_id.o.about[1].page_url }}">{{ remark_id.o.about[1].title|truncate:30 }}</a></p>
                    {% endif %}

                    <h4 class="remark-item__content__title">
                        {{ remark_id.title }}
                    </h4>
                    {{ remark_id.body|show_media }}
                </div>
                {% with remark_id.o.depiction as media %}
                {% with media|without_embedded_media:remark_id as deps %}
                    {% if deps %}
                        <div class="remark-item__media">
                            {% for dep in deps %}
                                {% if media|length > 1 %}
                                    {% if not remark_id.anonymous_name %}
                                        {% catinclude "remark-media/remark-media.image.tpl" dep remark_id=remark_id %}
                                    {% endif %}
                                {% else %}
                                    {% catinclude "remark-media/remark-media.image.tpl" dep remark_id=remark_id first %}
                                {% endif %}
                            {% endfor %}
                        </div>
                    {% endif %}
                {% endwith %}
                {% endwith %}
            </div>

            {% if remark_id.is_editable and not id.o.hasremark|index_of:remark_id.id %}
                <div class="remark-item__buttons">
                    <a href="#" class="remark-edit" title="{_ edit _}">{_ edit _}</a>
                    {% if m.acl.user %}
                        <a href="#" class="remark-delete" title="{_ delete _}">{_ delete _}</a>
                    {% endif %}
                </div>
            {% endif %}
        </article>
    </div>

    {% endwith %}

    {% javascript %}
        $(document).trigger('remark:viewing');
    {% endjavascript %}

    {% wire name="rsc_delete_"++remark_id action={dialog_delete_rsc id=remark_id on_success={script script="$(document).trigger('remark:deleted', " ++ remark_id ++ ");"}} %}
{% endif %}
