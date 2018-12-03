mod_ginger_activity
===================

A Zotonic module for tracking user activity on resources. At the moment this only covers the very 
basics.

This module is part of [Ginger](http://github.com/driebit/ginger).

Features:

* Register user triggers activity on a resource.
* Get activity totals.
* Log IP addresses.
* Notify users of activity on resources they are interested in.

Configuration
-------------

To persist activities in the database, set the `mod_ginger_activity.persist_activity` configuration
flag to `true`. 

Usage
-----

To register some activity:

```erlang
mod_ginger_activity:register_activity(RscId, TargetId, Context).
```

## Models

### m_ginger_activity_inbox

Get logged activities from a user's activity inbox. 

## Notifications

### ginger_activity_inserted

(Explain when the notification is sent and give a code example:)

```erlang
-export([
    observe_ginger_activity_inserted/2
]).

-include_lib("mod_ginger_activity/include/ginger_activity.hrl").

observe_ginger_activity_inserted(#ginger_activity_inserted{activity = Activity}, Context) ->
    %% your logic
    ok.
```

## Services

### Get activity stream

To get a user’s activity stream:

```http
GET /activities/inbox HTTP/1.1
Cookie: z_sid={user's session id}
```

The response follows [Activity Streams 2.0](https://www.w3.org/TR/activitystreams-core/) as closely
as possible:

```json
{
    "@context": "https://www.w3.org/ns/activitystreams",
    "type": "Collection",
    "items": [
        {
            "actor": {
                "name": "Jan Jansen",
                "type": "Person"
            },
            "id": "/nl/activities/inbox/7",
            "object": {
                "content": "<p>That's all nice and dandy, but...</p>",
                "id": "/nl/page/1111/remark",
                "name": "remark",
                "type": "remark"
            },
            "published": "2018-04-19T10:31:11Z",
            "target": {
                "id": "/nl/page/1110/dit-is-een-goede-vraag",
                "name": "Dit is een goede vraag",
                "type": "conversation"
            },
            "type": "Activity"
        },
        {
            "actor": {
                "name": "Jan Jansen",
                "type": "Person"
            },
            "id": "/nl/activities/inbox/8",
            "object": {
                "content": "<p>And yet another interesting remark!</p>",
                "id": "/nl/page/1112/remark",
                "name": "remark",
                "type": "remark"
            },
            "published": "2018-04-19T10:33:30Z",
            "target": {
                "id": "/nl/page/1110/good-questions",
                "name": "Some good questions!",
                "type": "conversation"
            },
            "type": "Activity"
        }
    ]
}
```

### Deleting activities from the stream

To delete a single item from the user’s stream (where `123` is the activity id):

```http
DELETE /activities/inbox/123 HTTP/1.1
Cookie: z_sid={user's session id}
```

To delete all activities from a user's stream:

```http
DELETE /activities/inbox HTTP/1.1
Cookie: z_sid={user's session id}
```

Roadmap
-------

- Get different kind of aggregates
- Create a custom fingerprint to uniquely indentify anonymous users
- Differentiate between different kinds of activity
- Higher throughput data persistence options
