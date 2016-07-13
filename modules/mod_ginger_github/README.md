mod_ginger_github
=================

A Zotonic module for interfacing with the [GitHub API](https://developer.github.com/).

Features:

* template model for GitHub API calls

Configuration
-------------

At http://yoursite/admin/modules, enable the module and click ‘Configure’ to
enter your [GitHub access token](https://github.com/settings/tokens).

Usage
-----

## Client

Use `github_client` to execute API calls from your Erlang code:

```erlang
Json = github_client:request("repos/driebit/ginger/issues", Context).
%% Returns a mochijson2 JSON structure.
```

See the [GitHub API docs](https://developer.github.com/) for all available API
calls.

## Models

This module provides an `m_github` template model so you can perform GitHub API
calls from your templates.

### m_github

Loop over GitHub milestones and list all closed issues in them:

```html+django
{% with m.github["repos/driebit/ginger/milestones?state=open"] as milestones %}
    <ol>
    {% for milestone in milestones %}
        <li>
            <h3>{{ milestone.title }}: {{ milestone.due_on|date:"M Y" }}</h3>
            {% with m.github["repos/driebit/ginger/issues?state=closed&milestone=" ++ milestone.number] as issues %}
                <ol>
                {% for issue in issues %}
                    <li><a href="{{ issue.html_url }}">{{ issue.title }}</a></li>
                {% endfor %}
                </ol>
            {% endwith %}
        </li>
    {% endfor %}
    <ol>
{% endwith %}
```
