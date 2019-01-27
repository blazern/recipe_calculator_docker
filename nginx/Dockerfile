FROM nginx:1.15.8

ARG LOCAL_SERVER_ADDRESS
ARG GLOBAL_SERVER_ADDRESS
ARG CERTIFICATE_PATH
ARG CERTIFICATE_KEY_PATH
ARG DHPARAM_PATH

RUN test $LOCAL_SERVER_ADDRESS \
    && test $GLOBAL_SERVER_ADDRESS \
    && test $CERTIFICATE_PATH \
    && test $CERTIFICATE_KEY_PATH \ 
    && test $DHPARAM_PATH

COPY server.conf /etc/nginx/conf.d/default.conf
RUN sed -i "s|LOCAL_SERVER_ADDRESS|$LOCAL_SERVER_ADDRESS|g" /etc/nginx/conf.d/default.conf \
 && sed -i "s|GLOBAL_SERVER_ADDRESS|$GLOBAL_SERVER_ADDRESS|g" /etc/nginx/conf.d/default.conf \
 && sed -i "s|CERTIFICATE_PATH|$CERTIFICATE_PATH|g" /etc/nginx/conf.d/default.conf \
 && sed -i "s|CERTIFICATE_KEY_PATH|$CERTIFICATE_KEY_PATH|g" /etc/nginx/conf.d/default.conf \
 && sed -i "s|DHPARAM_PATH|$DHPARAM_PATH|g" /etc/nginx/conf.d/default.conf

RUN echo "/etc/nginx/conf.d/default.conf:"
RUN cat /etc/nginx/conf.d/default.conf
