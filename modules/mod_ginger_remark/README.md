# mod_ginger_remark #

A Zotonic module for enabling comment like functionality. The main difference with the build in Zotonic module for comments is that remarks are actual resources in Zotonic instead of being stored in a separate table.

Features:

- Rich text editing
- Include uploaded media
- Embed external media
- Edit existing remarks
- Compatibility with Zotonic's Access Control Rules

Roadmap:

- Anonymous comments
- Spam protection
- Comment moderation screen
- Have a config key for setting the remarks content group

## Getting started ##

To enable remarks in your site, include `_remarks.tpl` on your resource’s page template, passing an optional `id` parameter for the resource on which you want users to be able to remark.

By default remarks will end up in the user generated content group (`cg_user_generated`). A set of default ACL rules are also included.

You can customize the behaviour of various Zotonic dialogs through overwriting different wires. Note that named wires have a global scope on the page. See for example `remark/remark-edit.tpl` where zlink and zmedia provide custom behaviour.
