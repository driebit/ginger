[![Build Status](https://travis-ci.org/driebit/ginger.svg?branch=master)](https://travis-ci.org/driebit/ginger)

Ginger
======

This is the Ginger Zotonic edition. This repository contains:

* (most) Ginger modules
* Docker configuration
* shell scripts

Documentation
-------------

* [Guidelines](docs/guidelines.md)
* [Why Ginger is a single Git repository](docs/monorepo.md)
* [Docker](docs/docker.md)
* [Templates](docs/templates.md)
* [Anymeta import](docs/anymeta-import.md)

Getting started
---------------

Clone this repository and install [Docker](https://www.docker.com/getdocker).

Then open a terminal in the Ginger directory and start the containers:

```bash
$ make up
```

To open a Zotonic shell:

```bash
$ make shell
```

Run [Gulp](https://github.com/driebit/docker-node-gulp) in the Ginger directory:

```bash
$ make gulp site=your_site_name
```

For more, see the [Docker](docs/docker.md) doc chapter.

Sites overview
---------------

* The [Zotonic status site](http://zotonic.com/docs/latest/installation/zotonic_status.html)
  is available at [http://localhost](http://localhost) for Docker or
  http://ginger.dev for Vagrant. Log in with empty password.

Checking out sites
------------------

1. Check out your Zotonic site in the `sites/` directory.
2. Start the site from the [status site]: http://localhost (Docker) or
   http://ginger.dev (Vagrant)
3. Login and go to the modules page
4. Deactive site module and activate it again
5. Now the site should work properly

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

This has become much easier with our Docker configuration. See
[Docker](docs/docker.md) for more information.

If you’re on Vagrant, read on.

Connect to the database:

```bash
$ sudo -u postgres psql
\l
\c
```

### Importing a database

From a file:

```bash
$ scripts/import.sh site-name site-name.sql
```

In ginger.dev environment, from a remote backup:

```bash
$ scripts/import-backup.sh your-username@ginger01.driebit.net site-name
```

Substitute `ginger-test.driebit.net` or `ginger-acceptatie.driebit.net` for
`ginger01.driebit.net` depending on the environment that you want to import
the latest backup from.

On ginger-test, you can leave out `your-username`:

```
$ scripts/import-backup.sh ginger01.driebit.net site-name
```

Fetching changes
----------------

```
$ git fetch
$ git rebase
```

Making changes
--------------

### Commit messages

Please follow the [Driebit guidelines for commit messages](https://gitlab.driebit.nl/driebit/docs/blob/master/git.md#commit-messages).
Additionally, prefix your message with the module that your change applies to.
For instance:

```
[admin] Fix login form styling
[foundation] Add carousel template
```

### Bugfixes to the release branch

When you are fixing a bug in the current release branch (as it is published on
ginger-test or ginger-acceptatie):

1. Fetch changes: `$ git fetch`.
2. View [branches](https://gitlab.driebit.nl/driebit/ginger/branches): `$ git branch -a`.
3. Switch to the latest release branch: `$ git checkout release-0.1.0`.
4. Make, commit and push your changes.
5. Optionally, update ginger-test with the your changes to the release branch:

```bash
$ ssh ginger-test.driebit.net
$ cd /srv/zotonic/
$ z git pull
$ z zotonic shell
$ z:m().
```
6. Optionally, the release branch to master:

```
git checkout master
git pull
git merge release-0.#.0 (latest release branch)
git push
```

### Feature developments

When working on (larger) features and fixes that should not be part of the
current release:

1. Fetch changes: `$ git fetch`.
2. Switch to master: `$ git checkout master`.
3. Make, commit and push your changes.

Deploying sites
---------------

To deploy a site, log in to the proper server (`ginger-test.driebit.net`,
`ginger-acceptatie.driebit.net` or `ginger01.driebit.net`):

```bash
$ ssh ginger-test.driebit.net
$ cd /srv/zotonic/sites/[site name]
```

Check the current Git branch, then pull the latest changes:

```bash
$ z git pull
```

Then compile the changes and flush the site:

```bash
$ z zotonic shell
$ z:compile(), z:flush([site name]).
```

License
-------

Ginger is released under the Apache 2.0 License. See the included LICENSE file
for more information.
