#!/bin/bash

# Import a SQL backup over SSH
URL=$1
SITE=$2

HOST="localhost"
USER="zotonic"
PASSWORD="ginger"
SCHEMA="public"
BACKUP_DIR="/srv/zotonic/sites/$SITE/files/backup"
DOWNLOAD_DIR="/tmp"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"

RECENT_BACKUP=`ssh zotonic@$URL ls "$BACKUP_DIR/*.sql" -t | head -n1 | xargs -n1 basename`

if [ ! -f "$DOWNLOAD_DIR/$RECENT_BACKUP" ]; then
    echo "Downloading $RECENT_BACKUP from $URL..."
    scp zotonic@$URL:$BACKUP_DIR/$RECENT_BACKUP $DOWNLOAD_DIR
fi

echo "Importing $RECENT_BACKUP..."
$DIR/import.sh $SITE $DOWNLOAD_DIR/$RECENT_BACKUP
