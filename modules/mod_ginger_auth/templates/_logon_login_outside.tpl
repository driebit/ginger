{% if zotonic_dispatch == `logon` or zotonic_dispatch == `signup` %}
    {% all include "_logon_link.tpl" %}
{% else %}
    {# Don't show sign up link, as it's available in a separate tab in the modal logon dialog #}
{% endif %}
