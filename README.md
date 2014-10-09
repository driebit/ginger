Ginger
======

This is the Ginger Zotonic edition.

Development environment
-----------------------

Use Vagrant to start the development environment. See
[our docs](https://gitlab.driebit.nl/driebit/docs/blob/master/vagrant.md)
for more info.

Sites overview
---------------

* The [Zotonic status site](http://zotonic.com/docs/latest/installation/zotonic_status.html)
  is available at [http://ginger.dev:8000](http://ginger.dev:8000). Log in
  with empty password.

Checking out sites
------------------

1. Check out your Zotonic sites in the `sites/` directory.
2. Run `$ vagrant provision`.
3. The site now appears in the [status site](http://ginger.dev:8000)
   and is available at `[sitename].dev`.

Adding modules
--------------

Place custom modules in `modules/` (no symlinks needed).
