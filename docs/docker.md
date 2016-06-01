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

2. Run `docker-composer up` by specifying an additional configuration file:

    ```bash
    $ docker-compose -f docker-compose.yml -f docker-compose.zotonic.yml up
    ```

3. If you wish to point to a Zotonic clone in another directory, override the
   `ZOTONIC` environment variable:

    ```bash
    $ ZOTONIC=/some/other/zotonic/dir docker-compose -f docker-compose.yml -f docker-compose.zotonic.yml up
    ```
