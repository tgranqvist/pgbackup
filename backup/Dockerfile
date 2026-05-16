FROM debian:trixie-20260406-slim

LABEL org.opencontainers.image.authors="Tom Granqvist"
LABEL org.opencontainers.image.source="https://github.com/tgranqvist/pgbackup"
LABEL org.opencontainers.image.licenses="BSD-3-Clause"

# Latest releases available at https://github.com/aptible/supercronic/releases
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.44/supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=6eb0a8e1e6673675dc67668c1a9b6409f79c37bc \
    SUPERCRONIC=supercronic-linux-amd64

COPY pgdg.sources /etc/apt/sources.list.d/pgdg.sources

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl \
 && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc \
      -o /usr/share/keyrings/apt.postgresql.org.asc \
 && apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client-18 \
    age \
    zstd \
 && rm -rf /var/lib/apt/lists/*

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

COPY logging.sh /usr/local/bin/lib/logging.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY backup.sh /usr/local/bin/backup.sh

RUN chmod +x /usr/local/bin/backup.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]