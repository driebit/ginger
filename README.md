Instructions for checking out/activating this module into Ginger
-----------------------------------------------------

1. checkout the module into your ginger/modules folder (NOT ginger/sites)
2. 'vagrant up' if ginger is not running
3. 'vagrant ssh'
4. 'cd /opt/zotonic/priv/modules'
5. 'ln -sfn /vagrant/modules/mod_ginger_admin .'
6. 'zotonic stop'
7. 'zotonic start'
8. 'zotonic shell'
9. 'z:m().'
10. go to the /admin URL of the site and log in
11. Go to System --> Modules
12. Activate the new module
13. go to System --> Status
14. Rescan modules
15. Flush system caches

Export/import database
----------------------

Export your database, where `zwartsjansma` is the schema name of the site
that you want to export:

```bash
$ cd modules/mod_admin_ginger
$ ./export.sh zwartsjansma
```
Import an exported `.sql` file, where `zwartsjansma` is the schema name of the
site that you want to import the data to:

```bash
$ cd modules/mod_admin_ginger
$ ./import.sh zwartsjansma
```