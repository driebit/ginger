Docker development environment
==============================

Zotonic development
-------------------

By default, the latest `0.x` Zotonic version is used. If you wish to do
development work on Zotonic files:

1. Clone Zotonic into a directory one level above Ginger:

    ```bash
    $ pwd
    /bli/bla/ginger
    $ cd ..
    $ git clone https://github.com/zotonic/zotonic.git
    ```

2. Start the containers loading your Zotonic volume:

    ```bash
    $ make up-zotonic
    ```

    This will compile Zotonic so it starts properly even after changing Zotonic
    branches or versions.

    If you wish to point to a Zotonic clone in another directory, override the
    `ZOTONIC` environment variable:

    ```bash
    $ ZOTONIC=/some/other/zotonic/dir make up-zotonic
    ```

3. To run the Zotonic tests:

    ```bash
    $ docker-compose -f docker-compose.yml -f docker-compose.zotonic.yml run zotonic test
    ```

Database
--------

Connect to PostgreSQL:

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

Elasticsearch
-------------

The Ginger Docker setup includes an Elasticsearch container. You can use Kibana
for querying Elasticsearch. Kibana is available at `http://localhost:5601`. 
Click on ‘Dev Tools’ to open up a console where you can enter Elasticsearch
queries.

Troubleshooting
---------------

### Zotonic start error: {not_running,filezcache}

This is a known issue in Zotonic: https://github.com/zotonic/zotonic/issues/1321.

```
zotonic_1   | 09:58:40.559 [error] Zotonic start error: {not_running,filezcache}
zotonic_1   | erl_call: failed to connect to node zotonic001@3aa4f137ecdc
zotonic_1   | Zotonic is not running. You need to start Zotonic first to use this command.
```

**Solution**:

```bash
$ rm -rf ../zotonic/priv/mnesia/*
```

The `make up` command already does this for you.

### Automatic recompilation does not work

Inotify is not picking up changes.

**Solutions**:

* If you’re using IntelliJ (PHPStorm, WebStorm), disable ‘Use “safe write”’ 
  in IntelliJ’s preferences.

* Click the Docker icon, Preferences, Uninstall/Reset and finally the ‘Reset’
  button.

### `make gulp` fails with ‘EEXIST: file already exists’

This seems to be related to [osxfs](https://docs.docker.com/docker-for-mac/osxfs/).

**Solution:**

Install Docker for Mac [beta](https://docs.docker.com/docker-for-mac/) instead of 
stable, which includes some fixes for osxfs.

### Unknown runtime specified default

On starting the docker container you get an error similar to this one

```
ERROR: for postgres  Unknown runtime specified default
ERROR: Encountered errors while bringing up the project.
```

**Solution:**

```bash
$ docker-compose down -v
```

