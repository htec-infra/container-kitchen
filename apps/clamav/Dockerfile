FROM alpine:3.17.2
ARG VERSION
ENV CLAM_VERSION=${VERSION:-"0.105.2-r0"}

RUN apk add --no-cache clamav=$CLAM_VERSION clamav-libunrar=$CLAM_VERSION

# Add clamav user
RUN adduser -S -G clamav -u 1000 clamav_user -h /var/lib/clamav && \
    mkdir -p /var/lib/clamav && \
    mkdir /usr/local/share/clamav && \
    chown -R clamav_user:clamav /var/lib/clamav /usr/local/share/clamav /etc/clamav

# Configure Clam AV...
COPY --chown=clamav_user:clamav conf/*.conf /etc/clamav/

# permissions
RUN mkdir /var/run/clamav && \
    chown clamav_user:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav

USER 1000

# initial update of av databases
RUN freshclam

VOLUME /var/lib/clamav

EXPOSE 3310
ENTRYPOINT ["clamd"]

