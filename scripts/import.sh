#!/bin/bash

USER="zotonic"
HOST="localhost"
DB=$1
FILE=$2
PASSWORD="ginger"
SCHEMA="public"

# Do service instead of systemctl to be compatible with ginger-test,
# which is still on Wheezy
sudo service stop zotonic

sudo -u postgres psql -c "drop database $DB"
sudo -u postgres psql -c "create database $DB ENCODING 'UTF8' TEMPLATE template0"
sudo -u postgres psql ginger -c "GRANT ALL ON SCHEMA $SCHEMA TO $USER"
PGPASSWORD="$PASSWORD" psql $DB -U $USER -h $HOST -f $FILE

sudo service start zotonic
