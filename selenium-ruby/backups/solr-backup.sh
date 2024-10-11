# #!/bin/bash

# # # Define variables
BIBLIO_CORE="biblio-search"
PN_CORE="pn-search"
MORPH_CORE="morph-search"
SOLR_URL="http://localhost:8983/solr"
# SNAPSHOT_NAME="20240913185922221"
BIBLIO_BACKUP_LOCATION="/opt/solr/server/solr/biblio-search/data/snapshot.20240919154139836"
PN_BACKUP_LOCATION="/opt/solr/server/solr/pn-search/data/snapshot.20240919154042991"
MORPH_BACKUP_LOCATION="/opt/solr/server/solr/morph-search/data/snapshot.20240919153922194"
SOLR_BACKUP_LOCATION="${SOLR_BACKUP_URL:-https://automation.lib.duke.edu/papyri-automation/}"

# If USE_SOLR_BACKUPS is not set to true, do the following:
if [ "$USE_SOLR_BACKUPS" != "true" ]; then
  /bin/sh -c /home/solr/start-solr.sh
else
  # Check to see if /opt/solr/server/solr/backups/biblio-search exists
  if [ ! -d "/opt/solr/server/solr/backups/biblio-search" ] ||
    [ ! -d "/opt/solr/server/solr/backups/pn-search" ] ||
    [ ! -d "/opt/solr/server/solr/backups/morph-search"]; then
    echo "Backups not found grabbing data from lib automation..."
    wget -r --no-parent -P "/opt/solr/server/solr/backups" -nH --cut-dirs=1 --reject "index.html*" $SOLR_BACKUP_LOCATION || exit 1
  fi

  solr-foreground &

  # Create the Solr cores
  sleep 5 && 

  unzip /opt/solr/server/solr/backups/biblio-search/snapshot.20240919154139836.zip -d $BIBLIO_BACKUP_LOCATION &&
  unzip /opt/solr/server/solr/backups/pn-search/snapshot.20240919154042991.zip -d $PN_BACKUP_LOCATION &&
  unzip /opt/solr/server/solr/backups/morph-search/snapshot.20240919153922194.zip -d $MORPH_BACKUP_LOCATION

  # # # Restore the backup
  curl "$SOLR_URL/$BIBLIO_CORE/replication?command=restore&name=20240919154139836" &
  curl "$SOLR_URL/$PN_CORE/replication?command=restore&name=20240919154042991" &
  curl "$SOLR_URL/$MORPH_CORE/replication?command=restore&name=20240919153922194" &

  wait
fi