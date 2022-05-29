ARG IMAGE

FROM ${IMAGE}

ARG DEBIAN_FRONTEND=noninteractive

ARG GIT_LFS_VERSION

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  curl \
  ca-certificates

COPY scripts/*.sh /usr/bin/

CMD ["start.sh"]
