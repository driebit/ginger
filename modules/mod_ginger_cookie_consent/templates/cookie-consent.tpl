{# See https://silktide.com/tools/cookie-consent/docs/installation/ #}

{% with
    message|default:_"This website uses cookies to ensure you get the best experience on our website.",
    dismiss|default:_"Got it!",
    learnMore|default:_"More info"
as
    message,
    dismiss,
    learnMore
%}
    {
        "message": "{{ message }}",
        "dismiss": "{{ dismiss }}",
        "learnMore": "{{ learnMore }}",
        "link": "{% if m.rsc.cookie_policy.is_visible %}{{ m.rsc.cookie_policy.page_url }}{% endif %}",
        "theme": false {# See cookie-consent.css #}
    }
{% endwith %}
