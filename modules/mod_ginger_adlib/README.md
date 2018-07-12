mod_ginger_adlib
================

This module offers integration between Zotonic and 
[Adlib](http://www.adlibsoft.nl). It is part of 
[Ginger](http://github.com/driebit/ginger).

Features:

* Full import of Adlib databases into Elasticsearch.
* Template model for displaying Adlib data in Zotonic templates.

Configuration
-------------

In the admin, on the Modules page, enable the module and click the ‘Configure’
button to enter the URL to your Adlib API instance.

Usage
-----

## Pulling data from the Adlib API

Pull records from the Adlib API that have been changed since a moment in time 
(e.g., 1 week):

```erlang
mod_ginger_adlib:pull_updates("-1 week", Context).
```

Pull a single record from Adlib (where `collect` is the Adlib database and
`123` the Adlib priref):

```erlang
mod_ginger_adlib:pull_record(<<"collect">>, 123, Context).
```

## Search

In your template:

```dtl
{% with m.search[{adlib search="all" database="photo" pagelen=10}] as records %}
    {% for record in records %}
        {% with m.ginger_adlib[record] as record %}
            {{ record['object.title'] }}
            {# And other record properties #}
        {% endwith %}}
    {% endfor %}
{% endwith %}

```

## Models

### m.ginger_adlib
