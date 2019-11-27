#!/bin/bash
set -e

test $USERS_PASSWORD

createuser recipe_calculator_server
createuser recipe_calculator_client
createdb recipe_calculator_main
psql -c "GRANT ALL ON schema public TO recipe_calculator_server;"
psql -c "ALTER USER recipe_calculator_server WITH SUPERUSER;"
psql -c "ALTER USER recipe_calculator_server with encrypted password '$USERS_PASSWORD'";
psql -c "ALTER USER recipe_calculator_client with encrypted password '$USERS_PASSWORD'";
