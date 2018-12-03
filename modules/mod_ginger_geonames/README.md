mod_ginger_geonames
===================

A Zotonic module for looking up place names in [GeoNames](http://www.geonames.org).

This module is part of [Ginger](http://github.com/driebit/ginger).

Features:

* [reverse geocoding](http://www.geonames.org/export/reverse-geocoding.html)

Configuration
-------------

Enable the module, then go to System > Modules > GeoNames > Configure and enter
your [GeoNames username](http://www.geonames.org/export/).
      
Usage
-----

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
