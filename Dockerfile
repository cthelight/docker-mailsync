FROM debian:12-slim

# Allow multi-arch builds to target different supercronic binaries
ARG TARGETARCH
ARG CRON_SCHEDULE
ARG MBSYNC_CMD
# Install relevant packages
# Default to running daily
ENV CRON_SCHEDULE="0 0 * * *"

# Let user select mbsync command to run
ENV MBSYNC_CMD="mbsync -V -a -c /config/mbsyncrc"

##########################
# Setup supercronic data
##########################
# Latest releases available at https://github.com/aptible/supercronic/releases
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.32/supercronic-linux-${TARGETARCH} \
    SUPERCRONIC=supercronic-linux-${TARGETARCH} \
    SUPERCRONIC_SHA1SUM="SUPERCRONIC_SHA1SUM_${TARGETARCH}" \
    SUPERCRONIC_SHA1SUM_amd64=7da26ce6ab48d75e97f7204554afe7c80779d4e0 \
    SUPERCRONIC_SHA1SUM_arm=fe4f85bfb08631189ee8a20fae02294d90856aa7 \
    SUPERCRONIC_SHA1SUM_arm64=7f89438e7810669d3e0ea488a202aaf422cc2fdf

# Need to use bash here for fancier expansion support
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update
RUN apt-get -y install ca-certificates isync curl

# Pull down supercronic
RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${!SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

# Setup start script
COPY ./start.sh /usr/bin/start.sh
RUN chmod a+x /usr/bin/start.sh

# Go
ENTRYPOINT ["/usr/bin/start.sh"]
