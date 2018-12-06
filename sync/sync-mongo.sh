# !/usr/bin/bash

set -ex

echo "Syncing data from $PRODUCTION_MONGO_URL to $STAGING_MONGO_URL"

mongodump --uri="$PRODUCTION_MONGO_URL"

mongorestore --uri="$STAGING_MONGO_URL" --dir=./dump/ --drop --stopOnError
