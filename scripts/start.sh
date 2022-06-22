#!/bin/bash
# Copyright (c) 2022 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

# Test if PREFIX location is whithin limits
if [[ ! "${PREFIX}" == "/usr/local" && ! "${PREFIX}" =~ ^"/opt" ]]; then
  echo "ERROR:  PREFIX set to '${PREFIX}'. Must either be '/usr/local' or within '/opt'."
  exit 1
fi

cd /tmp
curl -sSLO https://github.com/git-lfs/git-lfs/releases/download/v${GIT_LFS_VERSION}/git-lfs-linux-$(dpkg --print-architecture)-v${GIT_LFS_VERSION}.tar.gz
if [[ ${GIT_LFS_VERSION//./} -ge 320 ]]; then
  tar xfz git-lfs-linux-$(dpkg --print-architecture)-v${GIT_LFS_VERSION}.tar.gz --no-same-owner
  cd git-lfs-${GIT_LFS_VERSION}
else
  tar xfz git-lfs-linux-$(dpkg --print-architecture)-v${GIT_LFS_VERSION}.tar.gz --no-same-owner --one-top-level
  cd git-lfs-linux-$(dpkg --print-architecture)-v${GIT_LFS_VERSION}
fi
sed -i 's/git lfs install/#git lfs install/g' install.sh

echo '
# According to https://www.debian.org/doc/debian-policy/ch-opersys.html#site-specific-programs
if [[ "$PREFIX" == "/usr/local" && -e /tmp/etc/staff-group-for-usr-local ]]; then
  perm=2775
  group=staff
else
  perm=755
  group=root
fi

mkdir -p $prefix/share
mkdir -m$perm -p $prefix/share/man
chown root:$group $prefix/share/man
mkdir -m$perm -p $prefix/share/man/man1
chown root:$group $prefix/share/man/man1
rm -rf $prefix/share/man/man1/git-lfs*

if [[ -d man/man1 ]]; then
  suffix=/man1
else
  suffix=
fi

pushd "$( dirname "${BASH_SOURCE[0]}" )/man$suffix" > /dev/null
  for g in *.1; do
    install -m0644 $g "$prefix/share/man/man1/$g"
  done
popd > /dev/null

mkdir -m$perm -p $prefix/share/man/man5
chown root:$group $prefix/share/man/man5
rm -rf $prefix/share/man/man5/git-lfs*

if [[ -d man/man5 ]]; then
  suffix=/man5
else
  suffix=
fi

pushd "$( dirname "${BASH_SOURCE[0]}" )/man$suffix" > /dev/null
  for g in *.5; do
    install -m0644 $g "$prefix/share/man/man5/$g"
  done
popd > /dev/null' >> install.sh

echo '#!/usr/bin/env bash
set -eu

prefix="/usr/local"

if [[ "${PREFIX:-}" != "" ]] ; then
  prefix=${PREFIX:-}
elif [[ "${BOXEN_HOME:-}" != "" ]] ; then
  prefix=${BOXEN_HOME:-}
fi

rm -rf $prefix/bin/git-lfs*
rm -rf $prefix/share/man/man1/git-lfs*
rm -rf $prefix/share/man/man5/git-lfs*

rmdir $prefix/share/man/man1 2>&1 | sed "s|^|INFO:   |"
rmdir $prefix/share/man/man5 2>&1 | sed "s|^|INFO:   |"' > uninstall.sh
chmod +x uninstall.sh

if [[ -f "${MODE}.sh" ]]; then
  ./${MODE}.sh
  echo "INFO:   Git LFS v${GIT_LFS_VERSION} at ${PREFIX} ${MODE}ed."
else
  echo "ERROR:  Execution mode '${MODE}' not supported!"
fi
