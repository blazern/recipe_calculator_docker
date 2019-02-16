## What

Dockerfiles and docker-compose.yaml to build and run https://github.com/blazern/recipe_calculator_server.

## How

1. PostgreSQL DB is in the `db` container, it starts first.
2. The `db_for_tests` container then starts and copies all data from `db`.
3. The server container (`server_app`) then starts, runs DB migrations on both `db` and `db_for_tests`, runs tests (using `db_for_tests`), then the actual server is started.
4. The `nginx` containers follows `server_app`, listens to the 80 port and passes all requests with prefix "broccalc" to `server_app`. Uses only HTTPS (note that `server_app` is incapable of HTTPS by itself).
5. The `certificate-renewer` container doesn't depend on the others, its job is to attempt to update the certificates used by `nginx` once a day (using certbot from Let's encrypt).

The `docker-compose.yaml` file requires several arguments to be used.

## Is this repo of any use to me?

No.