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
        <title>
            {% block title %}
                {% if id %}
                    {{ id.seo_title|default:id.title ++ " - " ++ m.config.site.title.value }}
                {% else %}
                    {{ m.config.site.title.value }}
                {% endif %}
            {% endblock %}
        </title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

        {% lib "dist/main.js" %}
        {% lib "dist/style.css" %}

        {% include "_html_head_seo.tpl" %}

        <link rel="apple-touch-icon" sizes="57x57" href="/lib/dist/assets/icons/apple-icon-57x57.png">
        <link rel="apple-touch-icon" sizes="60x60" href="/lib/dist/assets/icons/apple-icon-60x60.png">
        <link rel="apple-touch-icon" sizes="72x72" href="/lib/dist/assets/icons/apple-icon-72x72.png">
        <link rel="apple-touch-icon" sizes="76x76" href="/lib/dist/assets/icons/apple-icon-76x76.png">
        <link rel="apple-touch-icon" sizes="114x114" href="/lib/dist/assets/icons/apple-icon-114x114.png">
        <link rel="apple-touch-icon" sizes="120x120" href="/lib/dist/assets/icons/apple-icon-120x120.png">
        <link rel="apple-touch-icon" sizes="144x144" href="/lib/dist/assets/icons/apple-icon-144x144.png">
        <link rel="apple-touch-icon" sizes="152x152" href="/lib/dist/assets/icons/apple-icon-152x152.png">
        <link rel="apple-touch-icon" sizes="180x180" href="/lib/dist/assets/icons/apple-icon-180x180.png">
        <link rel="icon" type="image/png" sizes="192x192"  href="/lib/dist/assets/icons/android-icon-192x192.png">
        <link rel="icon" href="/lib/dist/assets/icons/favicon.ico">
        <meta name="msapplication-TileColor" content="#ffffff">
        <meta name="msapplication-TileImage" content="/lib/dist/assets/icons/ms-icon-144x144.png">
        <meta name="theme-color" content="#ffffff">
    </head>

    <body id="body">
        <script type="text/javascript">
            var app = Elm.Main.init();
        </script>
    </body>
</html>
