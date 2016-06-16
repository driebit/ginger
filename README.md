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

Install [Docker for Mac beta](https://beta.docker.com), which currently
requires you to sign up.

Then open a terminal in the Ginger directory and start the containers:

```bash
$ docker-compose up
```

To open a Zotonic shell:

```bash
$ make shell
```

Run [Gulp](https://github.com/driebit/docker-node-gulp) in a site directory:

```bash
$ docker run -it -v $(pwd):/app driebit/node-gulp
```

For more, see the [Docker](docs/docker.md) doc chapter.

Sites overview
---------------

* The [Zotonic status site](http://zotonic.com/docs/latest/installation/zotonic_status.html)
  is available at [http://localhost](http://localhost). Log in with empty password.

Checking out sites
------------------

1. Check out your Zotonic site in the `sites/` directory.
2. Start the site from the [status site](http://localhost)
3. Login and go to the modules page
4. Deactive site module and activate it again
5. Now the site should work properly

Adding modules
--------------

Place custom modules in `modules/` (no symlinks needed).

Database
--------

Connect to the database:

```
docker-compose exec postgres psql -U zotonic
```

### Import a database from a local file

1. Copy the database dump `.sql` file to the `data/` directory.

2. Then run:

    ```bash
    $ make import-db-file db=site-name file=site-dump.sql
    ```

### Import a database from a remote backup

1. If there are no backups yet, create a backup on the remote Zotonic site.

2. Then run:

    ```bash
    $ make import-db-backup host=ginger01.driebit.net site=site-name
    ```

Substitute `ginger-test.driebit.net` or `ginger-acceptatie.driebit.net` for
`ginger01.driebit.net` depending on the environment that you want to import
the latest backup from.

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
