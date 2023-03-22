ARG IMAGE
ARG PREFIX=/usr/local

FROM ${IMAGE} as installer

ARG DEBIAN_FRONTEND=noninteractive

ARG GIT_LFS_VERSION
ARG PREFIX
ARG MODE=install

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  curl \
  ca-certificates

COPY scripts/*.sh /usr/bin/

RUN start.sh

FROM scratch

LABEL org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://gitlab.b-data.ch/git-lfs/glfsi" \
      org.opencontainers.image.vendor="b-data GmbH" \
      org.opencontainers.image.authors="Olivier Benz <olivier.benz@b-data.ch>"

ARG PREFIX

COPY --from=installer ${PREFIX} ${PREFIX}
