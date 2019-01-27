FROM certbot/certbot:v0.30.0

# We'll attempt to update the certs at 12:00 each day.
ARG CRONTAB_RENEWAL_TIME="0 12 * * *"

# The Supercronic part is taken from https://github.com/Cethy/alpine-supercronic.
# Thanks, @Cethy!
ENV SUPERCRONIC_VERSION="v0.1.6" \
    SUPERCRONIC_PACKAGE=supercronic-linux-amd64

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/$SUPERCRONIC_VERSION/$SUPERCRONIC_PACKAGE

# install dependencies
# install supercronic
# remove unwanted deps
# cleanup
RUN apk add --update --no-cache ca-certificates curl \
    && curl -fsSLO "$SUPERCRONIC_URL" \
    && chmod +x "${SUPERCRONIC_PACKAGE}" \
    && mv "${SUPERCRONIC_PACKAGE}" "/bin/${SUPERCRONIC_PACKAGE}" \
    && ln -s "/bin/${SUPERCRONIC_PACKAGE}" /bin/supercronic \
    && apk del --purge ca-certificates curl \
    && rm -rf /tmp/* /var/cache/apk/*

# Write crontab file in the cron directory.
# Note that the dirs in args were used durint certificate acquiring -
# their paths are stored in certbot's config files and therefore cannot be changed
# without editing the config files.
RUN echo "$CRONTAB_RENEWAL_TIME certbot renew --config-dir=/etc/letsencrypt --work-dir=/var/lib/letsencrypt --logs-dir=/var/log/letsencrypt" > /etc/crontab

RUN chmod 0777 /etc/crontab

ENTRYPOINT supercronic /etc/crontab
