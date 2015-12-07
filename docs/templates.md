Writing templates
=================

Resource access (ACLs)
----------------------

When you display resources in a template, always check whether they are visible
to the current user.

For a single resource:

```
{% if id.is_visible %}
    {{ id.title }}
{% endif %}
```

For a list of resources use the `is_visible` filter:

```
{% for item in items|is_visible %}
    {{ item.name }} is visible!
{% endif %}
```

What exactly `is_visible` means must not be defined in the templates. Instead, 
it is defined through ACL rules and/or `acl_is_allowed` observers.