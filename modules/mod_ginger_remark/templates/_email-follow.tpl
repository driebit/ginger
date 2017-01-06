{% extends "email_base.tpl" %}

{% block title %}{_ Reaction added to _}: {{ about.title }}{% endblock %}

{% block body %}
    <p>Beste{% if person.name_first %} {{ person.name_first }}{% else %} {{ person.title }}{% endif %},</p>
    {% if author == "true" %}
        {# TODO: translations in email don't work? #}
        <p>Er is een nieuwe reactie op een verhaal dat je geschreven hebt:</p>
        {# {_ A new comment is posted on a story you authored _} #}
    {% else %}
        <p>Er is een nieuwe reactie op een verhaal dat je aan het volgen bent:</p>
        {# {_ A new comment is posted on a story you are following _} #}
    {% endif %}
    <table cellpadding="0" cellspacing="0" border="0" style="background-color: #f9f9f9;">
        <tr><td colspan="3" height="10"></td></tr>
        <tr>
            <td width="10"></td>
            <td width="615">
                <h2>{{ about.title }}</h2>
                <h3><a href="{{ about.page_url }}" style="text-decoration: none; color: #000;">{{ remark.title }}</a></h3>
                    <p>{% if remark.o.author.title %}{_ By _}: {{ remark.o.author.title }}, {% endif %} <time datetime='{{ id.date_end|date:"Y-t-dTH:m" }}'>{{ remark.publication_start|date:"j F Y" }}</time></p>
                <p>{{ remark.body|striptags|truncate:100:"..." }}</p>
                <p style="margin-top: 20px;"><a href="{{ about.page_url }}" style="padding: 10px 15px; border-radius: 3px; font-weight: bold; background: #000; color: #fff;">Bekijk reactie</a></p>
            </td>
            <td width="10"></td>
        </tr>
        <tr><td colspan="3" height="10"></td></tr>
    </table>
{% endblock %}
