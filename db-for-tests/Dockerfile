FROM recipe_calculator_docker_db
# We extend the not-testing image so that we'd inherit its initialization process.

# Declare, test and insert into env the path of _live_ DB.
ARG LIVE_DB_PATH
RUN test $LIVE_DB_PATH
ENV LIVE_DB_PATH $LIVE_DB_PATH

# Note that we intentionally named the .sh-script to be lexicographically
# bigger than `db-related-init.sh` - because of that it always executes after
# 'db-related-init.sh'.
# See https://hub.docker.com/_/postgres/ for mor info on execution order.
COPY second-db-related-init.sh /docker-entrypoint-initdb.d/