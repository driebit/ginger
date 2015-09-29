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
  is available at [http://ginger.dev](http://ginger.dev). Log in with empty password.

Checking out sites
------------------

1. Check out your Zotonic site in the `sites/` directory.
2. The site now appears on the [status site](http://ginger.dev), where you can
   start it.

Adding modules
--------------

Place custom modules in `modules/` (no symlinks needed).

Starting and stopping Zotonic
-----------------------------

Stop Zotonic: `$ sudo service zotonic stop`.

Start Zotonic: `$ sudo service zotonic start`.

Start Zotonic in debug mode: `$ zotonic debug`.

Database
--------

Connect to the database:

```bash
$ sudo -u postgres psql
\l
\c
```

Git branches/releases
---------------------
voor bugfixes:
switch je dev naar laatste release branch
 $ git fetch
 $ git branch -a
 $ git checkout release-0.1.0 (laatste) 
update ginger-test
 $ sudo -su zotonic
 $ cd /srv/zotonic/
 $ git pull
ginger-acceptatie wordt elke week ge-update (door david)
 $ 
ginger01 wordt de week daarna ge-update (door david)
 %

