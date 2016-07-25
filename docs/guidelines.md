Ginger Guidelines
=================

Everyone is invited to make changes to this document.

Please make a [merge request](https://github.com/driebit/ginger/pulls)
to suggest improvements and add clarifications. Please use [issues](https://github/driebit/ginger/issues)
to ask questions.

## Working on sites

### 1. Always enable mod_ginger_base. If possible, enable mod_ginger_foundation too.

All sites run on mod_ginger_base. As many as possible run on
mod_ginger_foundation.

### 2. Always check whether a resource is visible before displaying it.

* For single resources, use `{% if id.is_visible %}`.
* For lists, use the `items|is_visible` filter.

### 3. Override the smallest possible unit.

* Override only the templates you need and only the blocks you need.

* When overriding a base/foundation template, use `{% overrules %}` where
possible. Then only overwrite the blocks that you really need to overwrite.

### 4. Add site or module-specific JavaScript files to _script.tpl.

### 5. Add site or module-specific CSS files to _html_head.tpl.

### 6. Protect system content.

* In the ACL rules, never give users (including managers) access to
  ‘system content’. This prevents users from accidentally editing categories
   and content groups.

## Working on Ginger

### 7. Be backwards compatible.

* When changing templates, parameter names etc. always think about backwards
  compatibility.

* Other people and sites depend on you to make sure their code
  still works after your changes.

* If you need to introduce a breaking change, document it in the CHANGELOG.md
  file.

### 8. Commit *small bugfixes* to the current release branch

For instance `release-0.5.0`. Then *merge* the release branch including your
bugfix into master:

```bash
$ git checkout master
$ git merge release-0.5.0
```

### 9. Commit *new features* to the master branch.

They will then become part of the next Ginger release.

### 10. Create an issue before doing any significant work.

* This enables [others](https://about.gitlab.com/handbook/#gitlab-workflow) to 
keep track of changes and provide you with ideas.

* We tag issues to show them on the [roadmap](http://ginger.nl/roadmap).

### 11. Prefer catinclude over include.

`{% catinclude id %}` allows more specific template overrides.

### 12. Place custom Erlang functionality in observers.

Instead of copying .erl files, hook into the notifications that already exist
in Zotonic and Ginger.

### 13. Create useful Ginger modules.

* Base new Ginger modules on [mod_ginger_template](http://github.com/driebit/mod_ginger_template).

* Add a readme and a license.
