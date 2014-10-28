#!/bin/bash

USER="ginger"
HOST="localhost"
DATABASE=$1
FILE=$2
PASSWORD="ginger"
SCHEMA="public"

sudo service zotonic stop

sudo -u postgres psql -c "drop database $DB"
sudo -u postgres psql -c "create database $DB"
sudo -u postgres psql ginger -c "CREATE SCHEMA $SCHEMA"
sudo -u postgres psql ginger -c "GRANT ALL ON SCHEMA $SCHEMA TO $USER"
PGPASSWORD="$PASSWORD" psql ginger -U $USER -h $HOST -f $FILE

sudo service zotonic start
