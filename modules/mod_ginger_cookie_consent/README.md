mod_ginger_cookie_consent
=========================

A Zotonic module that integrates [Silktide’s Cookie Consent](https://silktide.com/tools/cookie-consent/) with Zotonic.

This module is part of [Ginger](http://github.com/driebit/ginger).

Features:

* extensible theme with minimal CSS that easily integrates with Ginger sites
* translated cookie messages

Configuration
-------------

### Cookie policy

By default, an unpublished `cookie_policy` page is created. If you wish to
link to a cookie policy in the cookie message, enter some text on the page and 
publish it. 

### Change messages and other configuration

Override `cookie-consent-config.tpl` in your site and pass any of the options 
you find in `cookie-consent.tpl`.
