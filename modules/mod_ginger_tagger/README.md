mod_ginger_tagger
=================

Ginger module for performing actions as a result of scanning RFID tags.

Usage
-----

You need to be authenticated with an OAuth2 client access token to perform API
calls. See [mod_oauth2](https://github.com/driebit/mod_oauth2) on how to obtain
such a token.

### Get user RFID

Get user that an RFID belongs to:

```http
GET /rfids/{id} HTTP/1.1
Authorization: Bearer {Client OAuth2 token}
```

### Add RFID to user

Attach a RFID to a user. This requires a [user access token](https://github.com/driebit/mod_oauth2#authorization-code-grant):

```http
POST /me/rfids HTTP/1.1
Authorization: Bearer {User OAuth2 token}
Content-Type: application/json
Accept: application/json

{
    "rfids": [
        "AB123456",
        "XZ987654"
    ]
}
```

### Report an RFID action

When an RFID tag has been scanned, report that action to the Tagger API. You
can attach any file contents either as a base64-encoded string in a JSON body
or as a multipart/form element.

As JSON body:

```http
POST /tagger/actions
Authorization: Bearer {Client OAuth2 token}
Content-Type: application/json
Accept: application/json

{
    "rfids": [
        "ABC12345",
        "DEF78901"
    ],
    "attachment": "base64-encoded image contents"
}
```

You also override the default object by specifying its id or URI:

```http
POST /tagger/actions
Authorization: Bearer {Client OAuth2 token}
Content-Type: application/json
Accept: application/json

{
    "rfids": [
        "ABC12345"
    ],
    "object_id": "http://yoursite.com/
}
```
