#!/bin/bash
set -e

# Ensure the path to live db is set.
test $LIVE_DB_PATH

# Copy live db.
cp -r $LIVE_DB_PATH/* /var/lib/postgresql/data/
