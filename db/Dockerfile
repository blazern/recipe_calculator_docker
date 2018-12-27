FROM postgres:9.5

# Declare params
ARG USERS_PASSWORD
RUN test $USERS_PASSWORD
ENV USERS_PASSWORD $USERS_PASSWORD

# Add users
RUN useradd -p $USERS_PASSWORD recipe_calculator_server
RUN useradd -p $USERS_PASSWORD recipe_calculator_client
RUN useradd -p $USERS_PASSWORD recipe_calculator_admin

# Initialization finish is in the .sh
COPY db-related-init.sh /docker-entrypoint-initdb.d/
