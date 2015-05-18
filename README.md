mod_ginger_tagger
=================

Ginger module for performing actions as a result of scanning RFID tags. 

Usage
-----

You need to be authenticated with an OAuth2 access token to perform API calls.
See [mod_oauth2](https://github.com/driebit/mod_oauth2) on how to obtain such a
token.

### Get user RFIDs

Get RFID and social media identities attached to it: 

```http
GET /rfids/{id} HTTP/1.1
Authorization: Bearer {OAuth2 token}
```
 
### Add RFID to user

Attach a RFID to a user:

```http
POST /rfids/{id} HTTP/1.1
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

