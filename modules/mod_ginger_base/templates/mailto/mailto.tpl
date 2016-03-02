{% with
    class|default:"mail-decode",
    text|default:"mail"
as
    class,
    text
%}

<a class="{{ class }} do_mail_decode" address="{{ address|mailencode }}" href="click.to.mail">{{ text }}</a>

{% endwith %}
