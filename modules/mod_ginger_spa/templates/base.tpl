<!DOCTYPE html>
<!--
#################################
      _      _      _     _ _
   __| |_ __(_) ___| |__ (_) |_
  / _` | '__| |/ _ \ '_ \| | __|
 | (_| | |  | |  __/ |_) | | |_
  \__,_|_|  |_|\___|_.__/|_|\__|

############ driebit ############

 geavanceerde internetapplicaties

        Oudezijds Voorburgwal 282
                1012 GL Amsterdam
                   020 - 420 8449
                  info@driebit.nl
                   www.driebit.nl

#################################
//-->
<html lang="{{ q.lang|default:"nl" }}">
    <head>
        <meta charset="utf-8" />
        <title>
            {% block title %}
            {% if id %}
                {{ id.seo_title|default:id.title ++ " - " ++ m.config.site.title.value }}
            {% else %}
                {{ m.config.site.title.value }}
            {% endif %}
            {% endblock %}
        </title>

        <link rel="icon" href="/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />

        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        {% block _html_head %}
        {% lib
            "bootstrap/css/bootstrap.css"
            "css/jquery.loadmask.css"
            "css/z.growl.css"
            "css/z.modal.css"
        %}
        {% endblock %}
        {% include "_js_include.tpl" %}
    </head>

    <body>
        {% block content_area %}{% block content %}{% endblock %}{% endblock %}
        {% script %}
    </body>
</html>
