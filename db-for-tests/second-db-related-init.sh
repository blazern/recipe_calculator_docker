#!/bin/bash
set -e

# Ensure the path to live db is set.
test $LIVE_DB_PATH

export SLEEP_TIME=10
echo "DB-tests container going to sleep for $SLEEP_TIME seconds"
sleep $SLEEP_TIME

# Copy live db.
cp -r $LIVE_DB_PATH/* /var/lib/postgresql/data/
