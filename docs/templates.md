Writing templates
=================

Resource access (ACLs)
----------------------

When you display resources in a template, always make sure whether they are
visible to the current user.

For a single resource:

```dtl
{% if id.is_visible %}
    {{ id.title }}
{% endif %}
```

For a list of resources use the `is_visible` filter:

```dtl
{% for item in items|is_visible %}
    {{ item.name }} is visible!
{% endif %}
```

What exactly `is_visible` must not be defined in the templates. Instead, it is
defined through ACL rules and/or `acl_is_allowed` observers.
