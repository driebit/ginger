#!/bin/bash

USER="zotonic"
HOST="localhost"
DB=$1
FILE="data/dump-${DB}.sql"

sudo service zotonic stop

sudo pg_dump -U $USER -h $HOST $DB > $FILE

sudo service zotonic start
