FROM rust:1.26.0

ARG VK_SERVER_TOKEN
ARG PSQL_URL_USER_ADMIN
ARG PSQL_URL_USER_SERVER
ARG PSQL_URL_USER_CLIENT
ARG SERVER_ADDRESS

RUN test $VK_SERVER_TOKEN \
 && test $PSQL_URL_USER_ADMIN \
 && test $PSQL_URL_USER_SERVER \
 && test $PSQL_URL_USER_CLIENT \
 && test $SERVER_ADDRESS

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        libpq-dev \
        libssl-dev \
        pkg-config

RUN cargo install diesel_cli --no-default-features --features postgres
COPY recipe_calculator_server recipe_calculator_server/
WORKDIR /recipe_calculator_server

ENV RUST_BACKTRACE 1
RUN cargo build --release

RUN echo { >> config.json \
 && echo \"vk_server_token\":\"$VK_SERVER_TOKEN\", >> config.json \
 && echo \"psql_url_user_server\":\"$PSQL_URL_USER_SERVER\", >> config.json \
 && echo \"psql_url_user_client\":\"$PSQL_URL_USER_CLIENT\", >> config.json \
 && echo \"psql_url_user_admin\":\"$PSQL_URL_USER_ADMIN\" >> config.json \
 && echo } >> config.json

RUN echo "config: " && cat config.json

ENV CONFIG_FILE_PATH config.json

# First - build tests without running them so that if one of them fails we
# wouldn't need to rebuild all tests to restart their run.
RUN cargo test --no-run

ENV PSQL_URL_USER_ADMIN $PSQL_URL_USER_ADMIN
ENV SERVER_ADDRESS $SERVER_ADDRESS
CMD diesel migration run --database-url="$PSQL_URL_USER_ADMIN" && \
    cargo test && \
    target/release/recipe_calculator_bin --config config.json --address $SERVER_ADDRESS