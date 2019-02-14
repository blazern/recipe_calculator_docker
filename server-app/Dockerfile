FROM rust:1.32.0

# Declare all expected args
ARG VK_SERVER_TOKEN
ARG DB_USERS_PASSWORD
ARG LIVE_DB_HOSTNAME
ARG TEST_DB_HOSTNAME
ARG SERVER_ADDRESS

# Test that all declared args are provided
RUN test $VK_SERVER_TOKEN \
 && test $DB_USERS_PASSWORD \
 && test $LIVE_DB_HOSTNAME \
 && test $TEST_DB_HOSTNAME \
 && test $SERVER_ADDRESS

# Declare env vars used in CMD
# Including Rust's backtraces to be printed on panics
ENV CONFIG_FILE_PATH testing_config.json \
    PSQL_TEST_URL_USER_ADMIN $PSQL_TEST_URL_USER_ADMIN \
    PSQL_LIVE_URL_USER_ADMIN $PSQL_LIVE_URL_USER_ADMIN \
    SERVER_ADDRESS $SERVER_ADDRESS \
    RUST_BACKTRACE 1

# Declare live and testing DB urls
ARG PSQL_LIVE_URL_USER_SERVER=postgres://recipe_calculator_server:$DB_USERS_PASSWORD@$LIVE_DB_HOSTNAME/recipe_calculator_main
ARG PSQL_LIVE_URL_USER_CLIENT=postgres://recipe_calculator_client:$DB_USERS_PASSWORD@$LIVE_DB_HOSTNAME/recipe_calculator_main
ARG PSQL_LIVE_URL_USER_ADMIN=postgres://recipe_calculator_admin:$DB_USERS_PASSWORD@$LIVE_DB_HOSTNAME/recipe_calculator_main
ARG PSQL_TEST_URL_USER_SERVER=postgres://recipe_calculator_server:$DB_USERS_PASSWORD@$TEST_DB_HOSTNAME/recipe_calculator_main
ARG PSQL_TEST_URL_USER_CLIENT=postgres://recipe_calculator_client:$DB_USERS_PASSWORD@$TEST_DB_HOSTNAME/recipe_calculator_main
ARG PSQL_TEST_URL_USER_ADMIN=postgres://recipe_calculator_admin:$DB_USERS_PASSWORD@$TEST_DB_HOSTNAME/recipe_calculator_main

# Create live config and testing config
RUN echo { >> config.json \
  && echo \"vk_server_token\":\"$VK_SERVER_TOKEN\", >> config.json \
  && echo \"psql_url_user_server\":\"$PSQL_LIVE_URL_USER_SERVER\", >> config.json \
  && echo \"psql_url_user_client\":\"$PSQL_LIVE_URL_USER_CLIENT\" >> config.json \
  && echo } >> config.json \
  && echo "live config: " && cat config.json \
  \
  && echo { >> testing_config.json \
  && echo \"vk_server_token\":\"$VK_SERVER_TOKEN\", >> testing_config.json \
  && echo \"psql_url_user_server\":\"$PSQL_TEST_URL_USER_SERVER\", >> testing_config.json \
  && echo \"psql_url_user_client\":\"$PSQL_TEST_URL_USER_CLIENT\", >> testing_config.json \
  && echo \"psql_url_user_admin\":\"$PSQL_TEST_URL_USER_ADMIN\" >> testing_config.json \
  && echo } >> testing_config.json \
  && echo "testing config: " && cat testing_config.json

# Copy the actual server app code and cd into its dir
COPY recipe_calculator_server recipe_calculator_server/
WORKDIR /recipe_calculator_server

# Install all needed dependencies
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        libpq-dev \
        libssl-dev \
        pkg-config

# Install Diesel
RUN cargo install diesel_cli --no-default-features --features postgres

# Build a release binary
RUN cargo build --release \
    && rm -rf target/release/build \
              target/release/incremental \
              target/release/deps

# Build tests without running them so that if one of them fails we
# wouldn't need to rebuild all tests to restart their run.
RUN cargo test --no-run \
    && rm -rf target/debug/incremental

# Migrate testing DB and run tests on it,
# then migrate live DB and start the server app.
CMD diesel migration run --database-url="$PSQL_TEST_URL_USER_ADMIN" && \
    cargo test && \
    diesel migration run --database-url="$PSQL_LIVE_URL_USER_ADMIN" && \
    target/release/recipe_calculator_bin --config config.json --address $SERVER_ADDRESS
