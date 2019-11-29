FROM ubuntu:16.04

# Declare all expected args
ARG VK_SERVER_TOKEN
ARG DB_USERS_PASSWORD
ARG LIVE_DB_HOSTNAME
ARG TEST_DB_HOSTNAME
ARG SERVER_ADDRESS
ARG BINARY_PATH_TESTS
ARG BINARY_PATH_APP

# Test that all declared args are provided
RUN test $VK_SERVER_TOKEN \
 && test $DB_USERS_PASSWORD \
 && test $LIVE_DB_HOSTNAME \
 && test $TEST_DB_HOSTNAME \
 && test $SERVER_ADDRESS \
 && test $BINARY_PATH_TESTS \
 && test $BINARY_PATH_APP

# Install all needed dependencies
RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        build-essential \
        libpq-dev \
        libssl-dev \
        pkg-config

# Declare live and testing DB urls
ARG PSQL_LIVE_URL_USER_SERVER=postgres://recipe_calculator_server:$DB_USERS_PASSWORD@$LIVE_DB_HOSTNAME/recipe_calculator_main
ARG PSQL_LIVE_URL_USER_CLIENT=postgres://recipe_calculator_client:$DB_USERS_PASSWORD@$LIVE_DB_HOSTNAME/recipe_calculator_main
ARG PSQL_TEST_URL_USER_SERVER=postgres://recipe_calculator_server:$DB_USERS_PASSWORD@$TEST_DB_HOSTNAME/recipe_calculator_main
ARG PSQL_TEST_URL_USER_CLIENT=postgres://recipe_calculator_client:$DB_USERS_PASSWORD@$TEST_DB_HOSTNAME/recipe_calculator_main

# Create live config
RUN echo { >> config.json \
  && echo \"vk_server_token\":\"$VK_SERVER_TOKEN\", >> config.json \
  && echo \"psql_url_user_server\":\"$PSQL_LIVE_URL_USER_SERVER\", >> config.json \
  && echo \"psql_url_user_client\":\"$PSQL_LIVE_URL_USER_CLIENT\", >> config.json \
  && echo \"db_connection_attempts_timeout_seconds\": 180 >> config.json \
  && echo } >> config.json
RUN echo "live config: " && cat config.json

# Create testing config
RUN echo { >> testing_config.json \
  && echo \"vk_server_token\":\"$VK_SERVER_TOKEN\", >> testing_config.json \
  && echo \"psql_url_user_server\":\"$PSQL_TEST_URL_USER_SERVER\", >> testing_config.json \
  && echo \"psql_url_user_client\":\"$PSQL_TEST_URL_USER_CLIENT\", >> testing_config.json \
  && echo \"db_connection_attempts_timeout_seconds\": 180 >> testing_config.json \
  && echo } >> testing_config.json
RUN echo "testing config: " && cat testing_config.json

# Set Rust's backtraces to be printed on panics
ENV RUST_BACKTRACE 1

# Declare env vars used in CMD
ENV CONFIG_FILE_PATH testing_config.json
ENV SERVER_ADDRESS $SERVER_ADDRESS
ENV BINARY_PATH_TESTS $BINARY_PATH_TESTS
ENV BINARY_PATH_APP $BINARY_PATH_APP

# Run tests and start the server app.
CMD echo "testing config: " && cat testing_config.json && \
    echo "live config: " && cat config.json && \
    $BINARY_PATH_TESTS && \
    $BINARY_PATH_APP --config config.json --address $SERVER_ADDRESS
