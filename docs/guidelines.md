Ginger Guidelines
=================

## Templates

### 1. Always check whether a resource is visible before displaying it.

* For single resources, use `{% if id.is_visible %}`.
* For lists, use the `items|is_visible` filter.

### 2. Override the smallest possible unit.

Override only the templates you need and only the blocks you need. 

When overriding a base/foundation template, use `{% overrules %}` where 
possible. 

Then only overwrite the blocks that you really need to overwrite. 

### 3. Add site or module-specific JavaScript files to _script.tpl.

### 4. Add site or module-specific CSS files to _html_head.tpl.

### 5. Prefer catinclude over include.

`{% catinclude id %}` allows more specific template overrides. 
   
## Working on Ginger

### 6. Be backwards compatible.

When changing templates, parameter names etc. always think about backwards
compatibility. 

Other people and sites depend on you to make sure their code
still works after your changes.

### 7. Commit *bugfixes* to the current release branch, for instance release-0.5.0.

Then merge the release branch including your bugfix into master.

### 8. Commit new *features* to the master branch.

They will then become part of the next Ginger release.

## Working on sites

### 9. Always enable mod_ginger_base. As often as possible, enable mod_ginger_foundation too.

All sites run on mod_ginger_base. As many as possible run on 
mod_ginger_foundation.

### 10. Place custom Erlang functionality in observers.