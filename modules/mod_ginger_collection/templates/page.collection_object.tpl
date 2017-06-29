{% extends "beeldenzoeker/base.tpl" %}

{% block body_class %}t--adlib-object{% endblock %}

{% block title %}
    {% with m.collection_object[q.database][q.object_id]._source as record %}
        {{ record['dcterms:title'] }}
    {% endwith %}
{% endblock %}

{% block content %}

{% with m.collection_object[q.database][q.object_id]._source as record %}

    {% include "beeldenzoeker/depiction.tpl" record=record width=1600 height=1600 template="beeldenzoeker/masthead.tpl" %}

    <main>
        <div class="adlib-object__actions">
            <div class="main-container">
                {% include "beeldenzoeker/share.tpl" record=record %}
                {% include "beeldenzoeker/depiction.tpl" record=record template="beeldenzoeker/download.tpl" %}
            </div>
        </div>
        <article class="adlib-object__description">
            <header>
                <h6>Datering <span>1852 - 1891</span></h6>
                <h6>Vervaardiger <a href="">Johan Conrad Greive</a></h6>
            </header>

            {% block page_title %}
                <h1 class="page-title">{% include "beeldenzoeker/title.tpl" title=record['dcterms:title']|default:record.title %}</h1>
            {% endblock %}

            {% if record.title[2] %}
                <h2>{{ record.title[2] }}</h2>
            {% endif %}

            {% block item_summary %}
                {% if record['dcterms:abstract'] as abstract %}
                    <p class="summary">
                        {{ abstract }}
                    </p>
                {% endif %}
            {% endblock %}

            {% block item_body %}
                {% if record['dcterms:description'] as body %}
                    {% if body|length > 400 %}
                        <div id="adlib-desc" class="adlib-description">
                            <div class="adlib-description-readmore">
                                <h6 class="adlib-description__expand do_expand" data-parent="adlib-desc" data-content="adlib-desc-inner">{_ Detailed description _}</h6>
                            </div>
                            <div id="adlib-desc-inner" class="adlib-description__inner">
                                <p>{{ body }}</p>
                            </div>
                        </div>
                    {% else %}
                        <p>{{ body }}</p>
                    {% endif %}
                {% endif %}
            {% endblock %}
        </article>

        <aside class="adlib-object__aside">
            <div class="adlib-object__aside-item">
                <h6>Bron</h6>
                <p><a href="">Zuiderzee museum</a></p>
            </div>
            <div class="adlib-object__aside-item">
                <h6>Trefwoorden</h6>
                <ul>
                    <li><a href="">Tjotter</a></li>
                    <li><a href="">Museum</a></li>
                    <li><a href="">Zuiderzee</a></li>
                </ul>
            </div>
            <h6 class="adlib-meta__expand do_expand" data-parent="adlib-meta" data-content="adlib-meta-inner">Meer informatie</h6>
        </aside>

        <div id="adlib-meta" class="adlib-meta">
            <div id="adlib-meta-inner" class="adlib-meta__inner">
                {% include "beeldenzoeker/record-meta.tpl" record=record %}
            </div>
        </div>

        <article class="adlib-object__creator">

            <h5 class="adlib-object__section-label">
                Vervaardiger
            </h5>

            <section class="adlib-object__creator-image">
                <img src="https://upload.wikimedia.org/wikipedia/commons/5/59/Greive-portret.jpg" alt="">
            </section>

            <section class="adlib-object__creator-title">
                <div>
                    <h6>Kunstenaar</h6>
                    <h3>Johan Conrad Greive</h3>
                    <p>Amsterdam, 2 jan 1873</p>
                </div>
            </section>

            <!--<div class="adlib-object__creator-source">
                <h5>Bron: DPmedia</h5>
            </div>-->
            <section class="adlib-object__creator-body">
                <p>
                    Bloemstuk, polychroom; omlijsting: mangaan kader waarbinnen tussen twee gele kaders een mangaan omwikkelde blauwe staaf tussen gele hoekrosetjes. Groot veelkleurig boeket in konische mangaan vaas met gele ornamenten en blauwe oren; veel diverse bloemen w.o. roos, tulp, anemonen en korenaren bovenaan enkele insekten. Gelijmd op multiplex.
                </p>
            </section>

            <!--
            In het design staat hier behalve 'leesmeer' ook 'op www.rkd.nl', ik weet niet of dat er bij moet/handig is.
                    -->
            {% include "beeldenzoeker/readmore.tpl" url="#" text="Lees meer" class="adlib-object__creator-readmore"%}

        </article>

        <section class="adlib-object__related">
            <div class="adlib-object__related-header">
                <h2>Gerelateerd uit de Zuiderzee collectie</h2>
            </div>

            <div class="adlib-object__related-carousel">

                <h5 class="adlib-object__section-label">
                    Gerelateerd
                </h5>

                {% with
                    index|default:m.config.mod_ginger_adlib_elasticsearch.index.value ++ "," ++ m.config.mod_elasticsearch.index.value,
                    results_template|default:"list/list.tpl",
                    cat|default:['beeldenzoeker_query']
                    as
                        index,
                        results_template,
                        cat
                    %}
                    {% include "beeldenzoeker/search-query.tpl" custom_list_template="list/list-item-carousel.tpl" index=index class="list-carousel" query_id=query_id %}
                {% endwith %}

            </div>

        </section>

        <section class="adlib-object__keywords">
            <div class="adlib-object__keywords-header">
                <h2>Trefwoorden</h2>
            </div>



            {% with m.search[{ginger_search query_id=r pagelen=6 page=q.page}] as result %}
                {% include "list/list.tpl" items=result id=id hide_showmore_button list_id="list-"++r.id list_template="list/list-item-beeldenzoeker.tpl" %}
            {% endwith %}
        </section>

        {% if q.debug %}
            {% print record %}
        {% endif %}
    </main>

{% endwith %}

{% endblock %}
