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


Troubleshooting
---------------

### Zotonic start error: {not_running,filezcache}

```
zotonic_1   | 09:58:40.559 [error] Zotonic start error: {not_running,filezcache}
zotonic_1   | erl_call: failed to connect to node zotonic001@3aa4f137ecdc
zotonic_1   | Zotonic is not running. You need to start Zotonic first to use this command.
```

**Solution**:

```bash
$ rm -rf ../zotonic/priv/mnesia/*
```
