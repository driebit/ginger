mod_ginger_export
=================

Zotonic module for exporting resources, queries and collections to CSV.

Export resources
----------------

For users that have the use permission on `mod_export`, an ‘export’ button is
shown in the admin sidebar for each page.

Export groups of resources
--------------------------

Export all pages of a site except of type under Meta.

For excluding categories add the unique name in the query string.
Example: `scheme://hostname/ginger/export/csv?excludes[]=person&excludes[]=artifact`
