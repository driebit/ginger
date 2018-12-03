mod_ginger_geonames
===================

A Zotonic module for looking up place names in [GeoNames](http://www.geonames.org).

This module is part of [Ginger](http://github.com/driebit/ginger).

Features:

* [reverse geocoding](http://www.geonames.org/export/reverse-geocoding.html)
* view all GeoNames results for a resource’s geo coordinates
* manually search by name.

Configuration
-------------

Enable the module, then go to System > Modules > GeoNames > Configure and enter
your [GeoNames username](http://www.geonames.org/export/).
      
Usage
-----

### Search GeoNames

This module adds a ‘GeoNames’ tab to the find dialog. When adding an edge
in the admin, select this tab to search GeoNames for places. Each place that 
you select will be inserted as an [RDF resource](../mod_ginger_rdf/README.md).   

### Erlang

```erlang
geonames_client:find_nearby_place_name({52.08095165, 5.12768031549829}, Context).
```

returns:

```erlang
[#{<<"adminCode1">> => <<"09">>,
   <<"adminCodes1">> => #{<<"ISO3166_2">> => <<"UT">>},
   <<"adminName1">> => <<"Utrecht">>,
   <<"countryCode">> => <<"NL">>,
   <<"countryId">> => <<"2750405">>,
   <<"countryName">> => <<"Netherlands">>,
   <<"distance">> => <<"1.1614">>,
   <<"fcl">> => <<"P">>,
   <<"fclName">> => <<"city, village,...">>,
   <<"fcode">> => <<"PPLA">>,
   <<"fcodeName">> => <<"seat of a first-order administrative division">>,
   <<"geonameId">> => 2745912,
   <<"lat">> => <<"52.09083">>,
   <<"lng">> => <<"5.12222">>,
   <<"name">> => <<"Utrecht">>,
   <<"population">> => 290529,
   <<"toponymName">> => <<"Utrecht">>}]
```

### Models

#### m_geonames

To get the complete URI for a GeoNames place based on its id (e.g. `2759794`):

```dtl
{{ m.geonames[2759794].uri }}
```

To find place names based on a resource’s geo coordinates (e.g. resource `123`):

```dtl
{% for place in m.geonames[{geo_lookup id=123}] %}
    {% print place %}
{% endwith %}
```

To find place names through a textual query:

```dtl
{% for place in m.geonames[{search text="Haag"}] %}
    {% print place %}
{% endwith %}
```
