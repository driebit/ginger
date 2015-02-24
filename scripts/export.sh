#!/bin/bash

DB="ginger"
USER="ginger"
HOST="localhost"
SCHEMA=$1
FILE="data/dump.sql"

sudo service zotonic stop

sudo pg_dump -U $USER -h $HOST $DB > $FILE

sudo service zotonic start
