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
<html lang="NL">
    <head>
        <title>
            {% block title %}
                {% if id %}
                    {{ id.seo_title|default:id.title ++ " - " ++ m.config.site.title.value }}
                {% else %}
                    {{ m.config.site.title.value }}
                {% endif %}
            {% endblock %}
        </title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>

        {% lib "dist/main.js" %}
        {% lib "dist/style.css" %}

        {% include "favicon.tpl" %}
        {% include "mod_seo_html_head.tpl" %}
    </head>

    <body id="body">
        <script type="text/javascript">
            var app = Elm.Main.init();
        </script>
    </body>
</html>
